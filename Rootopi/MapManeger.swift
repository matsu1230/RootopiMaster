//
//  MapManeger.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/11/18.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import Foundation
import Parse

class MapManeger{
    var maps: Array<Maps> = []
    let size = CGSize(width: 50, height: 50)
    static let mapInstans = MapManeger()
    
    
    func fechComment(name: String, callBack: Maps -> Void) -> Void{
        let query = PFQuery(className: "Map_Table")
        query.whereKey("name", containsString: name)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock{ (maps, error) -> Void in
            if error == nil{
                self.maps = []
                for map in maps! {
                    let pName = map["pName"] as! String
                    let barcode = map["barcode"] as! String
                    let name = map["name"]as! String
                    let pImage = map["pImage"] as! PFFile
                    pImage.getDataInBackgroundWithBlock{(image, error) -> Void in
                        if error == nil {
                            UIGraphicsBeginImageContext(self.size)
                            let photo = UIImage(data: image!)
                            photo!.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
                            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                            let com = Maps(name: name, barcode: barcode, pName: pName, pImage: resizeImage)
                            //self.barcodeSerch.append(com)
                            callBack(com)
                        }
                        
                    }
                }
            }
            
        }
    }
    
}