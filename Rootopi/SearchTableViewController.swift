//
//  SearchTableViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/11/11.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    var keyWord : String?
    let commodity = CommodityManager.sheradInstance
    let manager = CommodityManager()
    var commArray : Array<Commodity> = []
    var selectedRow : Int?
    var id : Int?
    var category : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(self.category)
        let titleImageView: UIImageView? = UIImageView(image: UIImage(named: "logo"))
        self.navigationItem.titleView = titleImageView
        self.tableView.registerNib(UINib(nibName: "CommTableViewCell", bundle: nil), forCellReuseIdentifier: "CommTableViewCell")
        self.tableView.estimatedRowHeight = 120
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.commArray.removeAll()
        if category != nil {
            manager.serchCategory(self.category!, callBack: {commoditys in
                self.commArray.append(commoditys)
                self.tableView.reloadData()
                if commoditys.cName == nil{
                    self.tableView.reloadData()
                }
            })
        }else if keyWord != nil {
            manager.serchKeyWord(self.keyWord!, callBack: {commoditys in
                self.commArray.append(commoditys)
                self.tableView.reloadData()
                if commoditys.cName == nil{
                    self.tableView.reloadData()
                }
            })
            if self.commArray.isEmpty {
                manager.serchMekar(self.keyWord!, callBack: {commoditys in
                    self.commArray.append(commoditys)
                    print(self.commArray.count)
                    self.tableView.reloadData()
                    if commoditys.cName == nil{
                        self.tableView.reloadData()
                    }
                })
            }
        }
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
        return self.commArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommTableViewCell", forIndexPath: indexPath) as! CommTableViewCell
        cell.cNameLabel.text = commArray[indexPath.row].cName
        cell.pImageView.image = commArray[indexPath.row].photo
        if commArray.isEmpty {
            cell.cNameLabel.text = ""
            cell.pImageView.image = nil
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRow = indexPath.row
        for var i = 0; i < commodity.commoditys.count; i++ {
            if (commArray[self.selectedRow!].cName == commodity.commoditys[i].cName) {
                self.id = i
            }
        }
        performSegueWithIdentifier("toComm", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toComm" {
            let comVC : CommViewController = segue.destinationViewController as! CommViewController
            comVC.id = self.id
        }
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "fromFavorite" {
    let comVC : CommViewController = segue.destinationViewController as! CommViewController
    comVC.id = self.id
    }
    }*/
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let comVC : CommViewController = segue.destinationViewController as! CommViewController
    comVC.id = self.id
    }*/
    
    /*func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    print(self.keyWord)
    self.commArray.removeAll()
    manager.serchKeyWord(self.keyWord!, callBack: {commoditys in
    self.commArray.append(commoditys)
    print(self.commArray[0].cName)
    self.serchTable.reloadData()
    if commoditys.cName == nil{
    self.commArray.removeAll()
    //self.serchTable.cell
    self.serchTable.reloadData()
    }
    })
    }*/
    
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
