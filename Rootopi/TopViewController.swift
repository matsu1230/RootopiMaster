//
//  ViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/09.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    @IBOutlet weak var topView: UILabel!
    @IBOutlet weak var tumblrTitle: UILabel!
    @IBOutlet weak var comButton1: UIButton!
    @IBOutlet weak var comButton2: UIButton!
    @IBOutlet weak var tumblrButton: UIButton!
    

     let commodityCollection = CommodityManager.sheradInstance
    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let callback = { () -> Void in
                self.viewDidAppear(true)
            
            if self.count == 2 {
                self.viewSet()
            }
            self.count += 1

        }
        commodityCollection.fetcCommodity(callback)
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewSet(){
        let com = commodityCollection.commoditys
        let tumblr = DownloadsViewController.tumblrPhotos[0]
        let title = DownloadsViewController.tumblrTitle[0]
        comButton1.setBackgroundImage(com[0].photo, forState: .Normal)
        comButton2.setBackgroundImage(com[1].photo, forState: .Normal)
        let photoUrl = NSURL(string: tumblr as! String)
        let req = NSURLRequest(URL:photoUrl!)
        NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
            let tumblrImage = UIImage(data: data!)
            self.tumblrTitle.text = title as? String
            self.tumblrButton.setBackgroundImage(tumblrImage, forState: .Normal)
        }
    }
    
    @IBAction func comButton1Tap(sender: UIButton) {

        
    }
    
    @IBAction func comButton2Tap(sender: UIButton) {
    }
}

