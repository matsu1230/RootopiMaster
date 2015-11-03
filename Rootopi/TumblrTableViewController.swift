//
//  TumblrTableViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/28.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit
//import SwiftyJSON

class TumblrTableViewController: UITableViewController {
    
    let size = CGSize(width: 100, height: 100)
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //makeTableData()
        tableView.registerNib(UINib(nibName: "TumblrTableViewCell", bundle: nil), forCellReuseIdentifier: "TumblrTableViewCell")
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension

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
        return 20
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TumblrTableViewCell", forIndexPath: indexPath) as! TumblrTableViewCell
        let photoUrl = NSURL(string: DownloadsViewController.tumblrPhotos[indexPath.row] as! String)
        let req = NSURLRequest(URL:photoUrl!)
        NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
            UIGraphicsBeginImageContext(self.size)
            let photo = UIImage(data: data!)
            photo!.drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            cell.tumblrImage.image = resizeImage
            cell.tumblrLabel.text = DownloadsViewController.tumblrTitle[indexPath.row] as? String
        }
        
        return cell
            
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRow = indexPath.row
        //print(self.selectedRow)
        performSegueWithIdentifier("toTumblrView", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toTumblrView" {
            // 遷移先のViewContollerにセルの情報を渡す
            //let pname = CommentManager
            let cellVC : TumblrViewController = segue.destinationViewController as! TumblrViewController
            //managerPname = CommodityManager.sheradInstance.commoditys[self.selectedRow!].cName as String
            cellVC.id = self.selectedRow
            //print(comMa.pName!)
        }
    }
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
