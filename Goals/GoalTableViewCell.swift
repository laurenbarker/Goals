//
//  GoalTableViewCell.swift
//  Goals
//
//  Created by Lauren Barker on 11/12/15.
//  Copyright © 2015 Lauren Barker. All rights reserved.
//

import UIKit

class GoalTableViewCell: UITableViewCell {

    @IBOutlet weak var goalTitle: UILabel!
    @IBOutlet weak var goalGoal: UILabel!
    @IBOutlet weak var goalUnit: UILabel!
    
    var previousStepperValue: Int = 0
    
    @IBAction func updateValue(sender: UIStepper) {
        var newValue: [NSNumber]
        
        if previousStepperValue < Int(sender.value) {
            newValue = GoalTableViewController().updateGoal(goalTitle.text!, action: "increase")
        } else {
            newValue = GoalTableViewController().updateGoal(goalTitle.text!, action: "decrease")
        }
        goalGoal.text = String(newValue[0])
        
        if (Double(newValue[0]) < Double(newValue[1])) {
            self.backgroundColor = UIColor.whiteColor()
        } else {
            self.backgroundColor = UIColor.greenColor();
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
