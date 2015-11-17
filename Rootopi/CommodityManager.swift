//
//  CommodityManager.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/13.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import Foundation
import UIKit
import Parse

class CommodityManager {
    
    var commoditys: Array<Commodity> = []
    static let sheradInstance = CommodityManager()
    let size = CGSize(width: 100, height: 100)
    
    func fetcCommodity(callBack: () -> Void){
        let query = PFQuery(className: "P_Table")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {(commoditys, error) -> Void in
            if error == nil {
                self.commoditys = []
                for commodity in commoditys!{
                    let name = commodity["pName"] as! String
                    let day = commodity["day"] as! NSDate
                    let price = commodity["price"] as! Int
                    let maker = commodity["maker"] as! String
                    let calorie = commodity["calorie"] as! Int
                    let imageData: PFFile = commodity["pImage"] as! PFFile
                    imageData.getDataInBackgroundWithBlock({(image, error) -> Void in
                    if (error == nil) {
                        UIGraphicsBeginImageContext(self.size)
                        let photo = UIImage(data: image!)
                        photo!.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
                        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        let com = Commodity(name: name, price: price, calorie: calorie, maker: maker, photo: resizeImage!, release: day)
                            self.commoditys.append(com)
                            callBack()
                        }
                    })
                }
        }
    }
   }
}
