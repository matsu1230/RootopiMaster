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
    var tweetImages : Array<Commodity> = []
    var rankCommodity : Array<Commodity> = []
    var barcodeSerch: Array<Barcode> = []
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
                    let barcode = commodity["barcode"] as! String
                    let imageData: PFFile = commodity["pImage"] as! PFFile
                    imageData.getDataInBackgroundWithBlock({(image, error) -> Void in
                        if (error == nil) {
                            UIGraphicsBeginImageContext(self.size)
                            let photo = UIImage(data: image!)
                            let tweetImage = Commodity(photo: photo!)
                            self.tweetImages.append(tweetImage)
                            photo!.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
                            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                            let com = Commodity(name: name, price: price, calorie: calorie, maker: maker, photo: resizeImage!, release: day, barcode: barcode, tweetImage: photo!)
                            self.commoditys.append(com)
                            callBack()
                        }
                    })
                }
            }
        }
    }
    
    func barcodeCommodity(barcode: String, callBack: Barcode -> Void) -> Void {
        let query = PFQuery(className: "P_Table")
        query.whereKey("barcode", containsString: barcode)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock{(commodity, error) -> Void in
            if error == nil {
                self.barcodeSerch = []
                for comm in commodity! {
                    let name = comm["pName"] as! String
                    let barcode = comm["barcode"] as! String
                    let imageData: PFFile = comm["pImage"] as! PFFile
                    imageData.getDataInBackgroundWithBlock{(image, error) -> Void in
                        if error == nil {
                            UIGraphicsBeginImageContext(self.size)
                            let photo = UIImage(data: image!)
                            photo!.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
                            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                            let com = Barcode(name: name, photo: resizeImage!, barcode: barcode)
                            //self.barcodeSerch.append(com)
                            callBack(com)
                        }
                        
                    }
                }
            }
        }
    }
    
    func serchKeyWord(keyWord: String, callBack: Commodity -> Void) -> Void{
        let query = PFQuery(className: "P_Table")
        query.whereKey("pName", hasPrefix: keyWord)
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
                    let barcode = commodity["barcode"] as! String
                    let imageData: PFFile = commodity["pImage"] as! PFFile
                    imageData.getDataInBackgroundWithBlock({(image, error) -> Void in
                        if (error == nil) {
                            UIGraphicsBeginImageContext(self.size)
                            let photo = UIImage(data: image!)
                            photo!.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
                            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                            let com = Commodity(name: name, price: price, calorie: calorie, maker: maker, photo: resizeImage!, release: day, barcode: barcode, tweetImage: photo!)
                            callBack(com)
                        }
                    })
                }
            }
        }
    }
    
    func serchMekar(maker: String, callBack: Commodity -> Void) -> Void{
        let query = PFQuery(className: "P_Table")
        query.whereKey("maker", hasPrefix: maker)
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
                    let barcode = commodity["barcode"] as! String
                    let imageData: PFFile = commodity["pImage"] as! PFFile
                    imageData.getDataInBackgroundWithBlock({(image, error) -> Void in
                        if (error == nil) {
                            UIGraphicsBeginImageContext(self.size)
                            let photo = UIImage(data: image!)
                            photo!.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
                            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                            let com = Commodity(name: name, price: price, calorie: calorie, maker: maker, photo: resizeImage!, release: day, barcode: barcode, tweetImage: photo!)
                            callBack(com)
                        }
                    })
                }
            }
        }
    }
    
    func serchCategory(category: String, callBack: Commodity -> Void) -> Void{
        let query = PFQuery(className: "P_Table")
        query.whereKey("category", hasPrefix: category)
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
                    let barcode = commodity["barcode"] as! String
                    let imageData: PFFile = commodity["pImage"] as! PFFile
                    imageData.getDataInBackgroundWithBlock({(image, error) -> Void in
                        if (error == nil) {
                            UIGraphicsBeginImageContext(self.size)
                            let photo = UIImage(data: image!)
                            photo!.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
                            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                            let com = Commodity(name: name, price: price, calorie: calorie, maker: maker, photo: resizeImage!, release: day, barcode: barcode, tweetImage: photo!)
                            callBack(com)
                        }
                    })
                }
            }
        }
    }
    
    
    func serchRanl(callBack:  Array<Commodity> -> Void) -> Void{
        let query = PFQuery(className: "P_Table")
        query.orderByDescending("rank")
        query.limit = 10
        query.findObjectsInBackgroundWithBlock {(commoditys, error) -> Void in
            if error == nil {
                self.rankCommodity = []
                for commodity in commoditys!{
                    let name = commodity["pName"] as! String
                    let day = commodity["day"] as! NSDate
                    let price = commodity["price"] as! Int
                    let maker = commodity["maker"] as! String
                    let calorie = commodity["calorie"] as! Int
                    let barcode = commodity["barcode"] as! String
                    let rank = commodity["rank"] as! Int
                    let imageData: PFFile = commodity["pImage"] as! PFFile
                    imageData.getDataInBackgroundWithBlock({(image, error) -> Void in
                        if (error == nil) {
                            UIGraphicsBeginImageContext(self.size)
                            let photo = UIImage(data: image!)
                            photo!.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
                            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                            let com = Commodity(name: name, price: price, calorie: calorie, maker: maker, photo: resizeImage!, release: day, barcode: barcode, rank: rank)
                            self.rankCommodity.append(com)
                        }
                        callBack(self.rankCommodity)
                    })
                }
            }
        }
    }

    func serchView(callBack:  Array<Commodity> -> Void) -> Void{
        let query = PFQuery(className: "P_Table")
        query.orderByDescending("Viewrank")
        query.limit = 10
        query.findObjectsInBackgroundWithBlock {(commoditys, error) -> Void in
            if error == nil {
                self.rankCommodity = []
                for commodity in commoditys!{
                    let name = commodity["pName"] as! String
                    let day = commodity["day"] as! NSDate
                    let price = commodity["price"] as! Int
                    let maker = commodity["maker"] as! String
                    let calorie = commodity["calorie"] as! Int
                    let barcode = commodity["barcode"] as! String
                    let rank = commodity["Viewrank"] as! Int
                    let imageData: PFFile = commodity["pImage"] as! PFFile
                    imageData.getDataInBackgroundWithBlock({(image, error) -> Void in
                        if (error == nil) {
                            UIGraphicsBeginImageContext(self.size)
                            let photo = UIImage(data: image!)
                            photo!.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
                            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                            let com = Commodity(name: name, price: price, calorie: calorie, maker: maker, photo: resizeImage!, release: day, barcode: barcode, rank: rank)
                            self.rankCommodity.append(com)
                        }
                        callBack(self.rankCommodity)
                    })
                }
            }
        }
    }

    
}
