//
//  Barcode.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/11/27.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import Foundation

class Barcode {
    var cName: String!
    var photo: UIImage!
    var barcode: String!
    init(name: String, photo: UIImage,barcode: String){
        self.cName = name
        self.photo = photo
        self.barcode = barcode
    }
    
}
