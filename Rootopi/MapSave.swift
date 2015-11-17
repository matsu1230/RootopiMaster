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
    
    init(lat: Double, lon: Double, name: String){
        self.lat = lat
        self.lon = lon
        self.name = name
    }
    
    func save(){
        let commentObject = PFObject(className: "Map_Table")
        commentObject["lat"] = self.lat
        commentObject["lon"] = self.lon
        commentObject["name"] = self.name
        commentObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                print("保存完了")
            }
        }
    }
    
}
