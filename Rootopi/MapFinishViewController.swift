//
//  MapFinishViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/11/03.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class MapFinishViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleImageView: UIImageView? = UIImageView(image: UIImage(named: "logo"))
        self.navigationItem.titleView = titleImageView
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func toTopButtonTap(sender: UIButton) {
        //let top = TopViewController()
        let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("Download")
        //DownloadsViewController.flg = true
        self.navigationController?.showViewController(vc as! DownloadsViewController,  sender: vc)
        //self.navigationController(HomeNavigationViewController)
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
