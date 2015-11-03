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
    init(name: String, price: Int, calorie: Int, maker: String, photo: UIImage, release: NSDate){
        self.cName = name
        self.price = price
        self.calorie = calorie
        self.maker = maker
        self.day = release
        self.photo = photo
    }
    
    /*func save(){
        let comObject = PFObject(className: "P_Table")
        //print(cName)
        comObject["pName"] = cName
        comObject["price"] = price
        comObject["calorie"] = calorie
        comObject["maker"] = maker
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy'年'MM'月'dd'日'"
        day = formatter.dateFromString(release)
        print(formatter.dateFromString(release))
        comObject["day"] = day
        comObject["pImage"] = PFFile(data: photo)
        comObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                print("保存完了")
            }
        }
    }*/
}