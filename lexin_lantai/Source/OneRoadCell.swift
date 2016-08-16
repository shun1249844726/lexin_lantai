//
//  OneRoadCell.swift
//  lexin_lantai
//
//  Created by 徐顺 on 16/3/2.
//  Copyright © 2016年 徐顺. All rights reserved.
//

import UIKit

class OneRoadCell: UITableViewCell {
    
    @IBOutlet var planNumLabel: UILabel!
    @IBOutlet var planNameLabel: UILabel!
    @IBOutlet var roadNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
