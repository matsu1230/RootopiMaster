//
//  SerchSelectTableViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/12/07.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class SerchSelectTableViewController: UITableViewController, UISearchBarDelegate{
    
    @IBOutlet var serchTable: UITableView!
    @IBOutlet weak var commSerchBar: UISearchBar!
    
    var selectedRow : Int?
    var keyWord: String?
    var category : String?
    
    var catgoryArray = ["チョコ・飴・ガム・グミ","クッキー・ビスケット・パイ","スナック・せんべい・駄菓子","おつまみ・ドライフルーツ","アイス・シャーベット","清涼飲料水・炭酸飲料水","コーヒー飲料・乳飲料"]
    
    override func viewDidLoad() {
        let titleImageView: UIImageView? = UIImageView(image: UIImage(named: "logo"))
        self.navigationItem.titleView = titleImageView
        super.viewDidLoad()
        self.commSerchBar.delegate = self
        ///print(self.serchTable.c)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRow = indexPath.row
        print(indexPath.section)
        if(indexPath.section == 0){
            print(self.catgoryArray[indexPath.row])
            category = self.catgoryArray[self.selectedRow!]
            performSegueWithIdentifier("toSerch", sender: nil)
        }

    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        keyWord = commSerchBar.text
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        keyWord = commSerchBar.text
        performSegueWithIdentifier("toSerch", sender: nil)
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSerch" {
            // 遷移先のViewContollerにセルの情報を渡す
            let cellVC : SearchTableViewController = segue.destinationViewController as! SearchTableViewController
            if category != nil{
                cellVC.category = self.category
                category = nil
            }else if keyWord != nil {
                cellVC.category = nil
                cellVC.keyWord = self.keyWord
                keyWord = nil

            }
        }
    }
    
    // MARK: - Table view data source

   /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    
    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.serchTable.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
       // let cell = self.serchTable(tableView, cellForRowAtIndexPath: indexPath)
        cell.textLabel?.textColor = UIColor.redColor()
        print(cell.textLabel?.text)

        return cell
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
