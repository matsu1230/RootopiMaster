//
//  MapSave.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/11/03.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import Foundation
import Parse

class MapSave {
    var lat: Double?
    var lon: Double?
    var name: String?
    var barcode: String?
    var pName: String?
    var pImage: NSData?
    
    init(lat: Double, lon: Double, name: String, barcode: String, pName: String, pImage: NSData){
        self.lat = lat
        self.lon = lon
        self.name = name
        self.barcode = barcode
        self.pName = pName
        self.pImage = pImage
    }
    
    func save(){
        let mapObject = PFObject(className: "Map_Table")
        mapObject["lat"] = self.lat
        mapObject["lon"] = self.lon
        mapObject["name"] = self.name
        mapObject["barcode"] = self.barcode
        mapObject["pName"] = self.pName
        print(self.pName)
        mapObject["pImage"] = PFFile(data: self.pImage!)
        mapObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                print("保存完了")
            }
        }
    }
}
