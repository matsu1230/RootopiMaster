//
//  FavoriteTableViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/27.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var favoBar: UITabBarItem!
    @IBOutlet weak var favoTable: UITableView!
    
    var selectedRow: Int?
    
    let commodity = CommodityManager.sheradInstance
    var id : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.title = "お気に入り"
        favoTable.registerNib(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteTableViewCell")
        favoTable.delegate = self
        favoTable.dataSource = self
        Favorite.load()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if self.navigationController is FavoriteNavigationController {
            //viewDidLoad()
            favoTable.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Favorite.favorites.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteTableViewCell", forIndexPath: indexPath) as! FavoriteTableViewCell
        Favorite.load()
        //let com = CommodityManager.sheradInstance.commoditys[indexPath.row]
        //print(indexPath.row)
        print(Favorite.favorites, terminator: "")
        for (var j = 0; j < CommodityManager.sheradInstance.commoditys.count; j++){
            if (Favorite.favorites[indexPath.row] == CommodityManager.sheradInstance.commoditys[j].cName){
                cell.pName.text = CommodityManager.sheradInstance.commoditys[j].cName
                cell.pImage.image = CommodityManager.sheradInstance.commoditys[j].photo
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRow = indexPath.row
        for var i = 0; i < commodity.commoditys.count; i++ {
            if (Favorite.favorites[self.selectedRow!] == commodity.commoditys[i].cName) {
                self.id = i
            }
        }
        performSegueWithIdentifier("fromFavorite", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromFavorite" {
            let comVC : CommViewController = segue.destinationViewController as! CommViewController
            comVC.id = self.id
        }
    }
}
