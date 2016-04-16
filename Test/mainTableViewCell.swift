//
//  mainTableViewCell.swift
//  Test
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 Serhii Petrishenko. All rights reserved.
//

import UIKit

class mainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
