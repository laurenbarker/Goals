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
        
        print(goalTitle.text)
        if previousStepperValue < Int(sender.value) {
            GoalTableViewController().updateGoal(goalTitle.text!, action: "increase")
        } else {
            GoalTableViewController().updateGoal(goalTitle.text!, action: "decrease")
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
