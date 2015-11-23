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
        
        Flurry.logEvent("Goal_Created");
        
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
    
    
    
//    let alert = UIAlertController(title: "Incomplete Form", message: "One or more fields in the Goal form are empty. All fields must be complete to save a goal. ", preferredStyle: UIAlertControllerStyle.Alert)
//    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//    self.presentViewController(alert, animated: true, completion: nil)
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
