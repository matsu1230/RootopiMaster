//
//  FavoriteNavigationController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/27.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class FavoriteNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let titleImageView: UIImageView? = UIImageView(image: UIImage(named: "logo"))
        navigationItem.titleView = titleImageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
