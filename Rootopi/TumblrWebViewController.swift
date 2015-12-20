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
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        let titleImageView: UIImageView? = UIImageView(image: UIImage(named: "logo"))
        self.navigationItem.titleView = titleImageView
        webView.delegate = self
        LoadingProxy.set(self); //表示する親をセット
        LoadingProxy.on();//ローディング表示。非表示にする場合はoff
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
    
    //ページが読み終わったときに呼ばれる関数
    func webViewDidFinishLoad(webView: UIWebView) {
        LoadingProxy.off();//ローディング表示。非表示にする場合はoff
        //println("ページ読み込み完了しました！")
    }
    //ページを読み始めた時に呼ばれる関数
    func webViewDidStartLoad(webView: UIWebView) {
        LoadingProxy.on();//ローディング表示。非表示にする場合はoff

        //println("ページ読み込み開始しました！")
    }
    
    deinit {
        self.webView.delegate = nil
        self.url = nil
        self.webView.stopLoading()
        self.webView.loadHTMLString("", baseURL: nil)
        self.view.removeFromSuperview()
        print("解放")
    }
    
}
