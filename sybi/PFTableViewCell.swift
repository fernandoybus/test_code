//
//  PFTableViewCell.swift
//  sybi
//
//  Created by Gisele Sardas on 8/18/15.
//  Copyright (c) 2015 ybus. All rights reserved.
//

import UIKit

class PFTableViewCell: UITableViewCell {
    

    @IBOutlet weak var personal_pic: UIImageView!
    @IBOutlet weak var companylogo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var occupation: UILabel!
    @IBOutlet weak var company: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
