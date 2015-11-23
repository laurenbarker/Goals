//
//  AnalyticsViewController.swift
//  Goals
//
//  Created by Lauren Barker on 11/23/15.
//  Copyright © 2015 Lauren Barker. All rights reserved.
//

import UIKit
import Foundation

class AnalyticsViewController: UIViewController {
    
    @IBOutlet weak var secondEvent: UILabel!
    @IBOutlet weak var firstEvent: UILabel!
    @IBOutlet weak var thirdEvent: UILabel!
    @IBOutlet weak var fourthEvent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Flurry.logEvent("Analytics")
        loadData()
        
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "http://api.flurry.com/eventMetrics/Summary?apiAccessCode=PRQGR6S2NZK5WGR8YDT5&apiKey=6FJJ9XQKW77JTSHP97NG&startDate=2015-11-23&endDate=2015-11-27")!) {(data, response, returnError) in
  
            let jsonData: NSData = data!
            
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? NSDictionary {
                    if let events = jsonResult["event"]! as? [[String : AnyObject]] {
                        var count = 0
                        for event in events {
                            print(event["@eventName"])
                            
                            if count == 0 {
                                self.firstEvent.text = event["@eventName"] as? String
                            } else if count == 1 {
                                self.secondEvent.text = event["@eventName"] as? String
                            } else if count == 2 {
                                self.thirdEvent.text = event["@eventName"] as? String
                            } else if count == 3 {
                                self.fourthEvent.text = event["@eventName"] as? String
                            }
                            
                            count = count + 1
                        }
                        
                    }
                    
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
