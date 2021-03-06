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
    
    @IBOutlet weak var comTitle: UILabel!
    @IBOutlet weak var myScrollView: UIScrollView!
    var id : Int?
    
    
    let commodityCollection = CommodityManager.sheradInstance
    var count: Int = 0
    let titleImageView: UIImageView? = UIImageView(image: UIImage(named: "logo"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController = HomeNavigationViewController
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationItem.titleView = titleImageView
        
        let callback = { () -> Void in
            self.viewDidAppear(true)
            
            if self.count == 2 && DownloadsViewController.tumblrPhotos.count > 0{
                self.viewSet()
            }
            self.count += 1
            
        }
        commodityCollection.fetcCommodity(callback)
        //myScrollView.
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
        comTitle.text = com[0].cName
        //comButton2.setBackgroundImage(com[1].photo, forState: .Normal)
        //let photoUrl = NSURL(string: tumblr as! String)
       // let urlStr : String = tumblr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        //let photoUrl = NSURL(string: urlStr )
        //print(photoUrl)
                self.tumblrTitle.text = title as? String
                self.tumblrButton.setBackgroundImage(tumblr , forState: .Normal)

        /*let tumblrImage = UIImage(named: "star-on")
            self.tumblrTitle.text = title as? String
            self.tumblrButton.setBackgroundImage(tumblrImage, forState: .Normal)*/
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "toComView" {
            // 遷移先のViewContollerにセルの情報を渡す
            let vc : CommViewController = segue.destinationViewController as! CommViewController
            vc.navigationController?.navigationItem.titleView = titleImageView
            vc.id = self.id
        }else if segue.identifier == "toTumblrView" {
            let vc :TumblrViewController = segue.destinationViewController as! TumblrViewController
            vc.id = 0
        }
    }
    
    @IBAction func comButton1Tap(sender: UIButton) {
        self.id = 0
    }
    @IBAction func comButton2Tap(sender: UIButton) {
        self.id = 1
    }
    
    
}

