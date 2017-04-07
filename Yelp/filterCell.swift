//
//  filterCell.swift
//  Yelp
//
//  Created by Rui Mao on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class filterCell: UITableViewCell {
    @IBOutlet weak var switchLabel: UILabel!

    @IBOutlet weak var onSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
