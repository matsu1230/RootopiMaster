//
//  Commodity.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/13.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Commodity {
    var cName: String!
    var price: Int!
    var calorie: Int!
    var maker: String!
    var release: String!
    var photo: UIImage!
    var day: NSDate!
    var barcode: String!
    init(name: String, price: Int, calorie: Int, maker: String, photo: UIImage, release: NSDate, barcode: String){
        self.cName = name
        self.price = price
        self.calorie = calorie
        self.maker = maker
        self.day = release
        self.photo = photo
        self.barcode = barcode
    }
}