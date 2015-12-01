//
//  TumblrViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/31.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class TumblrViewController: UIViewController {
    
    @IBOutlet weak var tumblrphoto: UIImageView!
    @IBOutlet weak var tumblrtitle: UILabel!
    @IBOutlet weak var tumblrbody: UILabel!
    var id : Int?
    var err: NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSet()
        
        print(id!)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        //tumblrbody.text = DownloadsViewController.tumblrBodys[Int(id!)] as! String
    }
    
    func viewSet(){
        tumblrtitle.text = DownloadsViewController.tumblrTitle[Int(id!)] as? String
        let photoUrl = NSURL(string: (DownloadsViewController.tumblrPhotos[Int(id!)] as? String)!)
        if photoUrl != nil {
            let req = NSURLRequest(URL:photoUrl!)
            NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
                let image = UIImage(data:data!)
                self.tumblrphoto.image = image
            }
            
        }  else {
            print("aaaaaa")
            let tumblrImage = UIImage(named: "star-on")
            self.tumblrphoto.image = tumblrImage
        }
        
        do {
            self.tumblrbody.attributedText = try NSAttributedString(
                data: DownloadsViewController.tumblrBodys[Int(id!)].dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
                options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType],
                documentAttributes: nil)
        } catch let error as NSError {
            err = error
            self.tumblrbody.attributedText = nil
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
