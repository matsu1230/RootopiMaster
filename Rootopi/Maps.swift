//
//  Maps.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/12/02.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import Foundation

class Maps {
    var name: String?
    var barcode: String?
    var pName: String?
    var pImage: UIImage?
    
    init(name: String, barcode: String, pName: String, pImage: UIImage){
        self.name = name
        self.barcode = barcode
        self.pName = pName
        self.pImage = pImage
    }
}