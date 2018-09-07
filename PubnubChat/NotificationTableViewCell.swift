//
//  NotificationTableViewCell.swift
//  Project
//
//  Created by Apple on 05/09/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var timeLbl : UILabel!
    @IBOutlet weak var messageLbl : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
