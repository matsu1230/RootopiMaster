//
//  TumblrManager.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/28.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class TumblrManager {
    let urlString = "http://api.tumblr.com/v2/blog/omupro2015.tumblr.com/posts/text?api_key=bbhaWmEh5JZQ9hmMYGjHMqhycnMQXUDHSarwUXYGRYmcOzTRL8"
    
    // セルの中身
    static var cellItems = NSMutableArray()
    //セルの中身のURL
    static var cellUrl = NSMutableArray()
    //セルの中身の画像
    static var cellPhoto = NSMutableArray()
    //セルの中身のbody
    static var cellBody = NSMutableArray()
    
    //正規表現のパターン
    let patternPtag = "<p>.*?</p>"
    let patternH2tag = "<h2>.*?</h2>"
    let patternStrong = "<strong>.*?</strong>"
    let patternFigure = "<figure.*?>"
    let patternImg = "<img src=\""
    let patternImg2 = "\".+ d.+</figure>h.+"
    //↓ここから追加した正規表現
    let patternData = "data-orig-height=\".*\" data-orig-width=\".*\""
    let patternImgEx = "<img width=\".*\" height=\".*\" src=\""
    let patternImgAlt = "<img alt=\".*\" src=\""
    //↑ここまで
    let patternImg3 = "<img width=..... height=..... src=\""
    let patternImg4 = "\".+/></figure>"
    let patternImg5 = "<img width="
    let patternImg6 = ""
    let patternFigure2 = "<figure.*?></figure>"
    
    
    func makeTableData(callBack: () -> Void) {
        let url = NSURL(string: self.urlString)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error in
            // リソースの取得が終わると、ここに書いた処理が実行される
            var json = JSON(data: data!)
            _ = json["response"]["total_posts"].int
            //self.cellNum = total!
            for (var i = 0; i <= 19; i++){
                let titel = json["response"]["posts"][i]["title"]
                let url = json["response"]["posts"][i]["post_url"]
                let content = json["response"]["posts"][i]["body"].string
                
                let replace = ""
                let replaceStringPtag:String! = content!.stringByReplacingOccurrencesOfString(self.patternPtag, withString: replace, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                let replaceStringBody:String! = content!.stringByReplacingOccurrencesOfString(self.patternFigure2, withString: replace, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                let replaceStringH2tag:String! = replaceStringPtag!.stringByReplacingOccurrencesOfString(self.patternH2tag, withString: replace, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                let replaceStringStrongtag:String! = replaceStringH2tag!.stringByReplacingOccurrencesOfString(self.patternStrong, withString: replace, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                let replaceStringFigure:String! = replaceStringStrongtag!.stringByReplacingOccurrencesOfString(self.patternFigure, withString: replace, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                let replaceStringImg:String! = replaceStringFigure!.stringByReplacingOccurrencesOfString(self.patternImg, withString: replace, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                let replaceStringImg2:String! = replaceStringImg!.stringByReplacingOccurrencesOfString(self.patternImg3, withString: replace, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                let replaceStringImgUrl:String = replaceStringImg2!.stringByReplacingOccurrencesOfString(self.patternImg2, withString: replace, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                let replaceStringData:String = replaceStringImgUrl.stringByReplacingOccurrencesOfString(self.patternData, withString: replace, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                let replaceStringImgAlt:String = replaceStringData.stringByReplacingOccurrencesOfString(self.patternImgAlt, withString: replace, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                let replaceStringImgEx:String = replaceStringImgAlt.stringByReplacingOccurrencesOfString(self.patternImgEx, withString: replace, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                let replaceStringImgUrl2:String = replaceStringImgEx.stringByReplacingOccurrencesOfString(self.patternImg4, withString: replace, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                
                print("\(replaceStringImgUrl2) + \(i)", terminator: "")
                //print("\n")
                // = replaceStringBody
                TumblrManager.cellPhoto[i] = replaceStringImgUrl2 as String
                let info = "\(titel)"
                let urlinfo = "\(url)"
                TumblrManager.cellItems[i] = info
                TumblrManager.cellUrl[i] = urlinfo
                let body = "\(replaceStringBody)"
                TumblrManager.cellBody[i] = body
            }
            //self.transition()
        })
        callBack()
        task.resume()
    }
    
}