//
//  TumblrViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/31.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit
import Social

class TumblrViewController: UIViewController {
    
    @IBOutlet weak var tumblrphoto: UIImageView!
    @IBOutlet weak var tumblrtitle: UILabel!
    @IBOutlet weak var tumblrbody: UILabel!
    var id : Int?
    @IBOutlet weak var tweetButton: UIButton!
    var err: NSError?
    var myComposeView : SLComposeViewController!
    var photo : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSet()
        let titleImageView: UIImageView? = UIImageView(image: UIImage(named: "logo"))
        self.navigationItem.titleView = titleImageView
        self.tweetButton.setBackgroundImage(UIImage(named: "twitter"), forState: .Normal)
        print(id!)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func viewSet(){
        tumblrtitle.text = DownloadsViewController.tumblrTitle[Int(id!)] as? String
        photo = DownloadsViewController.tumblrPhotos[Int(id!)]

        self.tumblrphoto.image = photo

        
        do {
            self.tumblrbody.attributedText = try NSAttributedString(
                data: DownloadsViewController.tumblrBodys[Int(id!)].dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
                options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType],
                documentAttributes: nil)
        } catch{
            print("Unknown Error")
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "toTumblrWeb" {
            // 遷移先のViewContollerにセルの情報を渡す
            let cellVC : TumblrWebViewController = segue.destinationViewController as! TumblrWebViewController
            cellVC.url = DownloadsViewController.tumblrUrls[self.id!] as? String
            cellVC.image = self.tumblrphoto.image
        }
    }
    
    @IBAction func tapTweet(sender: UIButton) {
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        // 投稿するテキストを指定.
        myComposeView.setInitialText("てすと")
        
        let i = Int(id!)
        let urlStr : String = DownloadsViewController.tumblrUrls[i].stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let Requrl = NSURL(string: urlStr as String)
        myComposeView.addURL(Requrl)
        
        // myComposeViewの画面遷移.
        self.presentViewController(myComposeView, animated: true, completion: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let viewControllers = self.navigationController?.viewControllers {
            var existsSelfInViewControllers = true
            for viewController in viewControllers {
                // viewWillDisappearが呼ばれる時に、
                // 戻る処理を行っていれば、NavigationControllerのviewControllersの中にselfは存在していない
                if viewController == self {
                    existsSelfInViewControllers = false
                    // selfが存在した時点で処理を終える
                    break
                }
            }
            
            if existsSelfInViewControllers {
                print("前の画面に戻る処理が行われました")
                self.tumblrphoto = nil
                self.tumblrbody = nil
                self.tumblrtitle = nil
                self.photo = UIImage()
            }
        }
        super.viewWillDisappear(animated)
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
