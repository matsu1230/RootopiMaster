//
//  CommodityTable.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/19.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import Foundation

class CommodityTable {
    
    var cName: String!
    var photo: NSData!
init(name: String,photo: NSData){
     self.cName = name
     self.photo = photo
  }
}