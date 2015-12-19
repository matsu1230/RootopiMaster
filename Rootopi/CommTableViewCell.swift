//
//  CommTableViewCell.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/14.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class CommTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cNameLabel: UILabel!
    @IBOutlet weak var pImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cNameLabel.numberOfLines = 0
        pImageView.layer.cornerRadius = 40
        pImageView.layer.masksToBounds = true
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
