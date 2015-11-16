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
    @IBOutlet weak var goalControl: UIStepper!
    @IBOutlet weak var goalUnit: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
