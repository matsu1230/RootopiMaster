//
//  CommodityTableViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/09.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit
import Parse

class CommodityTableViewController: UITableViewController {
    
    
    let cmmodityCollection = CommodityManager.sheradInstance
    var selectedRow: Int?
    var maxRow: Int?
    //var managerPname = CommentManager.pName
    
    //var commoditys: Array = [CommodityManager.sheradInstance.commoditys.count]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let titleImageView: UIImageView? = UIImageView(image: UIImage(named: "logo"))
        self.navigationController?.title = "商品一覧"
        //self.navigationItem.titleView = titleImageView
        tableView.registerNib(UINib(nibName: "CommTableViewCell", bundle: nil), forCellReuseIdentifier: "CommTableViewCell")
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CommodityManager.sheradInstance.commoditys.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommTableViewCell", forIndexPath: indexPath) as! CommTableViewCell
        let com = CommodityManager.sheradInstance.commoditys[indexPath.row]
        print(CommodityManager.sheradInstance.commoditys.count, terminator: "")
        cell.pImageView.image = com.photo
        cell.cNameLabel.text = com.cName
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRow = indexPath.row
        performSegueWithIdentifier("toCommViewController", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toCommViewController" {
            let query = PFQuery(className:"P_Table")
            query.whereKey("pName", containsString: CommodityManager.sheradInstance.commoditys[self.selectedRow!].cName)
            query.getFirstObjectInBackgroundWithBlock {
                (objects: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else if let objects = objects {
                    objects.incrementKey("Viewrank")
                    objects.saveInBackground()
                }
                
            }
            // 遷移先のViewContollerにセルの情報を渡す
            let cellVC : CommViewController = segue.destinationViewController as! CommViewController
            //managerPname = CommodityManager.sheradInstance.commoditys[self.selectedRow!].cName as String
            cellVC.id = self.selectedRow
            //self.tableView.removeFromSuperview()
            //print(comMa.pName!)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
