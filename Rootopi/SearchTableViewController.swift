//
//  SearchTableViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/11/11.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var mySerchbar: UISearchBar!
    @IBOutlet var serchTable: UITableView!
    var keyWord : String?
    let manager = CommodityManager()
    var commArray : Array<Commodity> = []
    var yls: YahooLocalSearch = YahooLocalSearch()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        serchTable.registerNib(UINib(nibName: "CommTableViewCell", bundle: nil), forCellReuseIdentifier: "CommTableViewCell")
        serchTable.estimatedRowHeight = 120
        serchTable.rowHeight = UITableViewAutomaticDimension
        serchTable.delegate = self
        serchTable.dataSource  = self
        self.mySerchbar.delegate = self
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
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.keyWord = searchText
        print(keyWord)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommTableViewCell", forIndexPath: indexPath) as! CommTableViewCell

        cell.cNameLabel.text = commArray[indexPath.row].cName
        cell.pImageView.image = commArray[indexPath.row].photo
        return cell
    }
    

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print(self.keyWord)
        manager.serchKeyWord(self.keyWord!, callBack: {commoditys in
            self.commArray.append(commoditys)
            print(self.commArray[0].cName)
            self.serchTable.reloadData()
            if commoditys.cName == nil{
                self.commArray.removeAll()
                self.serchTable.reloadData()
            }
        })
    }
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
