//
//  TumblrWebViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/31.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class TumblrWebViewController: UIViewController,UIWebViewDelegate, UISearchBarDelegate  {
    
    @IBOutlet weak var webView: UIWebView!
    //@IBOutlet weak var imageView: UIImageView!
    
    var url : String?
    
    
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.url)
        //print(image)
        //self.imageView.image = image!
        openUrl(url!)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func openUrl(urlString: String){
        print(urlString, terminator: "")
        let urlStr : String = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let Requrl = NSURL(string: urlStr as String)
        //let Requrl = NSURL(string: urlString)
        print(Requrl)
        let urlRequest = NSURLRequest(URL: Requrl!)
        webView.loadRequest(urlRequest)
    }
    
    
    func openUrlInSafari(urlString: String){
        if let nsUrl = NSURL(string: urlString){
            UIApplication.sharedApplication().openURL(nsUrl)
        }
        
    }
    
}
