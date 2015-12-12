//
//  RankTableViewCell.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/12/11.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class RankTableViewCell: UITableViewCell {

    @IBOutlet weak var rankNumber: UILabel!
    @IBOutlet weak var rankImage: UIImageView!
    @IBOutlet weak var rankName: UILabel!
    @IBOutlet weak var rankCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        //cNameLabel.numberOfLines = 0
        rankImage.layer.cornerRadius = 10
        rankImage.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
