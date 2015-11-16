//
//  Goal.swift
//  Goals
//
//  Created by Lauren Barker on 11/12/15.
//  Copyright © 2015 Lauren Barker. All rights reserved.
//

import Foundation
import CoreData

@objc(Goal)
class Goal: NSManagedObject{
    
    @NSManaged var title: String;
    @NSManaged var goal: NSNumber;
    @NSManaged var unit: String;
    @NSManaged var increment: NSNumber;
    @NSManaged var interval: String;
    @NSManaged var current: NSNumber;
    
//    init?(title: String, goal: NSNumber, unit: String, increment: NSNumber, interval: String) {
//        
//        self.title = title
//        self.goal = goal
//        self.unit = unit
//        self.increment = increment
//        self.interval = interval
//        self.current = 0
//        
//        if title.isEmpty {
//            return nil
//        }
//    }
    
}
