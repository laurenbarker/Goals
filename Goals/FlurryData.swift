//
//  FlurryData.swift
//  Goals
//
//  Created by Lauren Barker on 11/23/15.
//  Copyright © 2015 Lauren Barker. All rights reserved.
//

import Foundation

class FlurryData: NSObject {
    
    // API Access code = PRQGR6S2NZK5WGR8YDT5
    // API Key = 6FJJ9XQKW77JTSHP97NG
    
    func loadData() {

        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "http://api.flurry.com/eventMetrics/Summary?apiAccessCode=PRQGR6S2NZK5WGR8YDT5&apiKey=6FJJ9XQKW77JTSHP97NG&startDate=2015-11-23&endDate=2015-11-27")!) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
    
        task.resume()
    }
    
    
    
    
    
}
