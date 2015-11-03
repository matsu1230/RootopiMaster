//
//  FavoriteTableViewCell.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/27.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var pName: UILabel!
    @IBOutlet weak var pImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        pName.numberOfLines = 0
        pImage.layer.cornerRadius = 50
        pImage.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
