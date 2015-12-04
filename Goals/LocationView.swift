//
//  LocationView.swift
//  Goals
//
//  Created by Lauren Barker on 11/16/15.
//  Copyright © 2015 Lauren Barker. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationView: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var gps_bool: UISwitch!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UITextView!
    
    @IBAction func saveSwitchPressed(sender: AnyObject) {
    
        NSUserDefaults.standardUserDefaults().setBool(gps_bool.on, forKey: switchKey)

    
    }
    
    var window: UIWindow?
    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"


    
    var switchState = true
    let switchKey = "switchState"
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
//    @IBAction func saveSwitchPressed(sender:AnyObject) {
////        if self.gps_bool.on {
////            self.switchState = true
////            NSUserDefaults.standardUserDefaults().setBool(self.switchState, forKey: switchKey)
////            NSUserDefaults.standardUserDefaults().synchronize()
////            print(NSUserDefaults.standardUserDefaults().boolForKey(switchKey))
////        } else {
////            self.switchState = false
////            NSUserDefaults.standardUserDefaults().setBool(self.switchState, forKey: switchKey)
////            NSUserDefaults.standardUserDefaults().synchronize()
////            print(NSUserDefaults.standardUserDefaults().boolForKey(switchKey))
////        }
//        
//        NSUserDefaults.standardUserDefaults().setBool(gps_bool.on, forKey: switchKey)
//
//    }
    
    @IBAction func resetClicked(sender: AnyObject) {
        gps_bool.setOn(false, animated: true);}
    
    
//    @IBAction func gps_bool(sender: UIButton) {
//        if gps_bool.on {
//            print("Switch is on")
//            gps_bool.setOn(false, animated:true)
//
//        } else {
//            print("Switch is off")
//            gps_bool.setOn(true, animated:true)
//        }
//    }
//    
//    func stateChanged(switchState: UISwitch) {
//        if switchState.on {
//            print("Switch is on")
////            gps_bool.setOn(false, animated:true)
//
//        } else {
//            print("Switch is off")
////            gps_bool.setOn(true, animated:true)
//        }
//    }
    
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        initLocationManager();
        return true
    } //SO

    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.restoreSwitchesStates();
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveSwitchesStates", name: "kSaveSwitchesStatesNotification", object: nil);

        
//        gps_bool.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        // Do any additional setup after loading the view.
    }
    
    
    func saveSwitchesStates() {
        NSUserDefaults.standardUserDefaults().setBool(gps_bool!.on, forKey: "gps_bool");
     
        
        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
    func restoreSwitchesStates() {
        gps_bool!.on = NSUserDefaults.standardUserDefaults().boolForKey("gps_bool");
        
    }

    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if gps_bool.on{
        
        
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        
        }
        
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            
            print(coord.latitude)
            print(coord.longitude)
        }//SO
        
        if locations.count == 0{
            //handle error here
            return
        }
        
        
        
        let newLocation = locations[0]
        
        print("Latitude = \(newLocation.coordinate.latitude)")
        print("Longitude = \(newLocation.coordinate.longitude)")
        
        
        let location = CLLocation(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude) //changed!!!
        print(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
                print(error)
                return
            }
            
            if placemarks?.count > 0 {
                let pm = placemarks![0]
                
                let addressLines = pm.addressDictionary!["FormattedAddressLines"] as! NSArray
                
                
                self.address.text = addressLines.componentsJoinedByString(", ")
                self.address.numberOfLines = 0
                
                
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
    }
    
    
    func locationManager(manager: CLLocationManager,
        didFailWithError error: NSError){
            print("Location manager failed with error = \(error)")
    }
    
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus){
            
            
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.Denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed to location Access"
                shouldIAllow = true
            }
            NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
            if (shouldIAllow == true) {
                NSLog("Location to Allowed")
                // Start location services
                locationManager.startUpdatingLocation()
            } else {
                NSLog("Denied access: \(locationStatus)")
            } //SOwerflow
    
            
            print("The authorization status of location services is changed to: ", terminator: "")
            
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                print("Authorized")
            case .AuthorizedWhenInUse:
                print("Authorized when in use")
            case .Denied:
                print("Denied")
            case .NotDetermined:
                print("Not determined")
            case .Restricted:
                print("Restricted")
            }
            
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true;
    }
    
    override func viewWillAppear(animated: Bool) {
        self.gps_bool.on = NSUserDefaults.standardUserDefaults().boolForKey(switchKey)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.resignFirstResponder()
        super.viewWillDisappear(animated)
        
    }
    
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func createLocationManager(startImmediately startImmediately: Bool){
        locationManager = CLLocationManager()
        if let manager = locationManager{
            print("Successfully created the location manager")
            manager.delegate = self
            if startImmediately{
                manager.startUpdatingLocation()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.becomeFirstResponder()
        
        /* Are location services available on this device? */
        if CLLocationManager.locationServicesEnabled(){
            
            /* Do we have authorization to access location services? */
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                /* Yes, always */
                createLocationManager(startImmediately: true)
            case .AuthorizedWhenInUse:
                /* Yes, only when our app is in use */
                createLocationManager(startImmediately: true)
            case .Denied:
                /* No */
                displayAlertWithTitle("Not Determined",
                    message: "Location services are not allowed for this app")
            case .NotDetermined:
                /* We don't know yet, we have to ask */
                createLocationManager(startImmediately: false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .Restricted:
                /* Restrictions have been applied, we have no access
                to location services */
                displayAlertWithTitle("Restricted",
                    message: "Location services are not allowed for this app")
            }
            
            
        } else {
            /* Location services are not enabled.
            Take appropriate action: for instance, prompt the
            user to enable the location services */
            print("Location services are not enabled")
        }
    }
    

}
