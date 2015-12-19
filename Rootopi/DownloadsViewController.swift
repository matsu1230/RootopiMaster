//
//  DownloadsViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/19.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit
import SwiftyJSON

class DownloadsViewController: UIViewController {
    
    let commodityCollection = CommodityManager.sheradInstance
    static var flg: Bool = false
    var count : Int = 0
    
    let size = CGSize(width: 300, height: 200)

    
    //let sectionNum = 1
    // 1セクションあたりのセルの行数
    var cellNum = 10
    // 取得するAPI
    let urlString = "http://api.tumblr.com/v2/blog/omupro2015.tumblr.com/posts/text?api_key=bbhaWmEh5JZQ9hmMYGjHMqhycnMQXUDHSarwUXYGRYmcOzTRL8"
    // セルの中身
    static var tumblrTitle = NSMutableArray()
    //セルの中身のURL
    static var tumblrUrls = NSMutableArray()
    //セルの中身の画像
    static var tumblrPhotos : Array<UIImage> = []
    
    //セルの中身のbody
    static var tumblrBodys = NSMutableArray()
    
    static var tumblr: Array<TumblrManager> = []
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let topImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        topImageView.image = UIImage(named: "toppage")
        self.view.addSubview(topImageView)
        self.makeTableData()
        let callback = { () -> Void in
            if self.count == 3 {
                self.transition()
            }
            self.count += 1
        }
        commodityCollection.fetcCommodity(callback)

        // Do any additional setup after loading the view, typically from a nib.
        //self.flg = load()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func transition() {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let next:UIViewController = storyboard.instantiateViewControllerWithIdentifier("toTopController") as UIViewController
        
        next.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        self.presentViewController(next, animated: true, completion: nil)
        
    }
    
    
    func makeTableData() {
        let url = NSURL(string: self.urlString)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error in
            // リソースの取得が終わると、ここに書いた処理が実行される
            var json = JSON(data: data!)
            let total = json["response"]["total_posts"].int
            self.cellNum = total!
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
                let photoUrl = NSURL(string: replaceStringImgUrl2)
                let req = NSURLRequest(URL : photoUrl!)
                NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
                    UIGraphicsBeginImageContext(self.size)
                    let photo = UIImage(data: data!)
                    photo!.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
                    let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    DownloadsViewController.tumblrPhotos.append(resizeImage)
                }
                let info = "\(titel)"
                let urlinfo = "\(url)"
                DownloadsViewController.tumblrTitle[i] = info
                DownloadsViewController.tumblrUrls[i] = urlinfo
                DownloadsViewController.tumblrBodys[i] = replaceStringBody
            }
        })
        task.resume()
    }
}
