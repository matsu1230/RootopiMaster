//
//  CommentTableViewCell.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/20.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
