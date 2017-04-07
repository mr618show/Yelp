//
//  filterCell.swift
//  Yelp
//
//  Created by Rui Mao on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
@objc protocol filterCellDelegate {
    @objc optional func filterCell(filterCell: filterCell, didChangeValue value: Bool)
  }

class filterCell: UITableViewCell {
    @IBOutlet weak var switchLabel: UILabel!

    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var delegate: filterCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        onSwitch.addTarget(self, action: #selector(filterCell.switchValueChanged), for: UIControlEvents.valueChanged)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func switchValueChanged() {
        print ("switch value changed.")
        
        delegate?.filterCell?(filterCell: self, didChangeValue: onSwitch.isOn)
        
        
    }

}
