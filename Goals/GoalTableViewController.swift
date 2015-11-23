//
//  GoalTableViewController.swift
//  Goals
//
//  Created by Lauren Barker on 11/12/15.
//  Copyright © 2015 Lauren Barker. All rights reserved.
//

import UIKit
import CoreData

class GoalTableViewController: UITableViewController {
    @IBOutlet weak var updateTable: UITableView!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var goals = [Goal]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        goals = loadSampleGoals()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return goals.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "GoalTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GoalTableViewCell
        
        // Configure the cell...
        let goal = goals[indexPath.row]
        cell.goalTitle.text = goal.title + " per " + goal.interval
        cell.goalUnit.text = goal.unit
        cell.goalGoal.text = String(goal.current)
        
        if Double(goal.current.doubleValue) >= Double(goal.goal.doubleValue) {
            cell.backgroundColor = UIColor.greenColor();
        }
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            managedObjectContext.deleteObject(goals[indexPath.row] as NSManagedObject)
            goals.removeAtIndex(indexPath.row)
            
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func loadSampleGoals() -> [Goal] {
        let fetchRequest = NSFetchRequest(entityName: "Goals")
        var goals = [Goal]()
        /* And execute the fetch request on the context */
        do{
            let goalList = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Goal]
            var goalCount = 0
            for goal in goalList{
                goalCount += 1
                
                print("Title = \(goal.title)")
                print("Goal = \(goal.goal)")
                print("Unit = \(goal.unit)")
                print("Increment = \(goal.increment)")
                print("Interval = \(goal.interval)")
                
                goals.append(goal)
            }
            print("Goal count = \(goalCount)")
            return goals
        } catch let error as NSError{
            print(error)
            return goals
        }
        
    }
    
    func updateGoal(title: String, action: String) -> [NSNumber] {
        let fetchRequest = NSFetchRequest(entityName: "Goals")
        
        var titleValue = title.componentsSeparatedByString(" per")
        let predicate = NSPredicate(format: "title == %@", titleValue[0])
        
        fetchRequest.predicate = predicate
        var newValue:[NSNumber] = [0, 0]
        
        /* And execute the fetch request on the context */
        do {
            let goalArray = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Goal]
            let goal = goalArray[0]
            
            if action == "increase" {
                goal.current = Double(goal.current.doubleValue) + Double(goal.increment.doubleValue)
                newValue[0] = goal.current
                newValue[1] = goal.goal
            } else {
                goal.current = Double(goal.current.doubleValue) - Double(goal.increment.doubleValue)
                newValue[0] = goal.current
                newValue[1] = goal.goal
            }
            
            do{
                try managedObjectContext.save()
            } catch let error as NSError{
                print("Failed to save the new goal. Error = \(error)")
            }
            
            return newValue
            
        } catch let error as NSError{
            print(error)
            return [0]
        }
    }
    
    
    override func motionEnded(motion: UIEventSubtype,
        withEvent event: UIEvent?) {
            
            if motion == .MotionShake{
                
                //Comment: to terminate app, do not use exit(0) bc that is logged as a crash.
                
                UIControl().sendAction(Selector("suspend"), to: UIApplication.sharedApplication(), forEvent: nil)
            }
            
            
            
    }
    
}