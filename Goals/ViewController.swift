//
//  ViewController.swift
//  Goals
//
//  Created by Lauren Barker on 11/15/15.
//  Copyright © 2015 Lauren Barker. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var intervalField: UITextField!
    @IBOutlet weak var incrementField: UITextField!
    @IBOutlet weak var unitField: UITextField!
    @IBOutlet weak var goalField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var addGoal: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height + 20
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let widthConstraint = NSLayoutConstraint(item:self.contentView,
            attribute: NSLayoutAttribute.Width,
            relatedBy:NSLayoutRelation.Equal,
            toItem:self.view,
            attribute: NSLayoutAttribute.Width,
            multiplier:1.0,
            constant:0
        );
        
        self.view.addConstraint(widthConstraint);
        
        let leftConstraint = NSLayoutConstraint(item:self.contentView,
            attribute: NSLayoutAttribute.Left,
            relatedBy:NSLayoutRelation.init(rawValue: 0)!,
            toItem:self.view,
            attribute: NSLayoutAttribute.Left,
            multiplier:1.0,
            constant:0
        );
        
        self.view.addConstraint(leftConstraint);
        
        let rightConstraint = NSLayoutConstraint(item:self.contentView,
            attribute:NSLayoutAttribute.Right,
            relatedBy:NSLayoutRelation.init(rawValue: 0)!,
            toItem:self.view,
            attribute: NSLayoutAttribute.Right,
            multiplier:1.0,
            constant:0
        );
        
        self.view.addConstraint(rightConstraint);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "addGoalSegue") {
            
            
            if (goalField.text == "" || titleField.text == "" || unitField.text == "" || incrementField.text == "" || intervalField.text == "" ){
                
                let alert = UIAlertController(title: "Incomplete Form", message: "One or more fields in the Goal form are empty. All fields must be complete to save a goal. ", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            else {
                
                createNewGoalWithTitle(titleField.text!, goal: Double(goalField.text!)!, unit: unitField.text!, increment: Double(incrementField.text!)!, interval: intervalField.text!)
                
            }}
    }
    
    func createNewGoalWithTitle(title: String,
        goal :Double,
        unit: String,
        increment: Double,
        interval: String) -> Bool{
            
            let newGoal =
            NSEntityDescription.insertNewObjectForEntityForName("Goals",
                inManagedObjectContext: managedObjectContext) as! Goals.Goal
            
            
            
            (newGoal.title, newGoal.goal, newGoal.unit, newGoal.increment, newGoal.interval, newGoal.current) =
                (title, goal, unit, increment, interval, 0)
            
            
            do{
                try managedObjectContext.save()
                
                
                
            } catch let error as NSError{
                print("Failed to save the new goal. Error = \(error)")
            }
            print("Saved")
            
            return false
            
    }
    
    @IBAction func addGoalAction(sender: AnyObject!) {
        
        createNewGoalWithTitle(titleField.text!, goal: Double(goalField.text!)!, unit: unitField.text!, increment: Double(incrementField.text!)!, interval: intervalField.text!)
        
    }
    
    override func motionEnded(motion: UIEventSubtype,
        withEvent event: UIEvent?) {
            
            if motion == .MotionShake{
                
                //Comment: to terminate app, do not use exit(0) bc that is logged as a crash.
                UIControl().sendAction(Selector("suspend"), to: UIApplication.sharedApplication(),
                    forEvent: nil)
            }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let name = "FormView"
        
        // The UA-XXXXX-Y tracker ID is loaded automatically from the
        // GoogleService-Info.plist by the `GGLContext` in the AppDelegate.
        // If you're copying this to an app just using Analytics, you'll
        // need to configure your tracking ID here.
        // [START screen_view_hit_swift]
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: name)

        let eventTracker: NSObject = GAIDictionaryBuilder.createScreenView().build()
        tracker.send(eventTracker as! [NSObject : AnyObject])
        // [END screen_view_hit_swift]
    }
    
}
