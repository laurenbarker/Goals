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
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var goals = [Goal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSampleGoals()
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
        cell.goalTitle.text = goal.title
        cell.goalUnit.text = goal.unit
        cell.goalGoal.text = String(goal.goal)

        return cell
    }
    
    func loadSampleGoals() {
        let fetchRequest = NSFetchRequest(entityName: "Goals")
        
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
                
                //let goal1 = Goal(title: goal.title, goal: goal.goal, unit: goal.unit, increment: goal.increment,  interval: goal.interval, goal.current)
                goals.append(goal)
            }
            print("Goal count = \(goalCount)")
         
        } catch let error as NSError{
            print(error)
        }
//        let goal1 = Goal(title: "Run", goal: 5.0, unit: "miles", increment: 1.0,  interval: "week")!
//        
//        let goal2 = Goal(title: "Study", goal: 10.0, unit: "hours", increment: 1.0,  interval: "week")!
//        
//        let goal3 = Goal(title: "Workout", goal: 4.0, unit: "hours", increment: 1.0,  interval: "week")!
//        
//        goals += [goal1, goal2, goal3]
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
