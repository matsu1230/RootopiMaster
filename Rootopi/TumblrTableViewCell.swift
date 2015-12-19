//
//  TumblrTableViewCell.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/28.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class TumblrTableViewCell: UITableViewCell {

    @IBOutlet weak var tumblrImage: UIImageView!
    @IBOutlet weak var tumblrLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        tumblrLabel.numberOfLines = 0
        tumblrImage.layer.cornerRadius = 40
        tumblrImage.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
