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
        cell.goalTitle.text = goal.title + " per " + goal.interval
        cell.goalUnit.text = goal.unit
        cell.goalGoal.text = String(goal.current)
        
        if Double(goal.current.doubleValue) >= Double(goal.goal.doubleValue) {
            cell.backgroundColor = UIColor.greenColor();
        }

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
       
                goals.append(goal)
            }
            print("Goal count = \(goalCount)")
         
        } catch let error as NSError{
            print(error)
        }

    }
    
    func updateGoal(title: String, action: String) {
        let fetchRequest = NSFetchRequest(entityName: "Goals")
        
        var titleValue = title.componentsSeparatedByString(" per")
        let predicate = NSPredicate(format: "title == %@", titleValue[0])
        
        fetchRequest.predicate = predicate
        
        
        
        /* And execute the fetch request on the context */
        do {
            let goalArray = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Goal]
            let goal = goalArray[0]
                
                print("Title = \(goal.title)")
                print("Goal = \(goal.goal)")
                print("Increment = \(goal.increment)")
                print("Current = \(goal.current)")
            
            if action == "increase" {
                goal.current = Double(goal.current.doubleValue) + Double(goal.increment.doubleValue)
            } else {
                goal.current = Double(goal.current.doubleValue) - Double(goal.increment.doubleValue)
            }
            
            do{
                try managedObjectContext.save()
            } catch let error as NSError{
                print("Failed to save the new goal. Error = \(error)")
            }
            
        } catch let error as NSError{
            print(error)
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
