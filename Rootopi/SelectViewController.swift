//
//  SelectViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/11/02.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit
import MapKit
import Parse

class SelectViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var shopListTable: UITableView!
    @IBOutlet weak var comImageView: UIImageView!
    @IBOutlet weak var pNameLabel: UILabel!
    
    var addBtn: UIBarButtonItem!
    var myNavigationController: UINavigationController?
    var selectedRow: Int?
    var barcode : String?
    
    let manager = CommodityManager()

    
    var myLocationManager:CLLocationManager!
    let yls: YahooLocalSearch = YahooLocalSearch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopListTable.registerNib(UINib(nibName: "ShopTableViewCell", bundle: nil), forCellReuseIdentifier: "ShopTableViewCell")
        shopListTable.delegate = self
        shopListTable.dataSource = self
        
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.distanceFilter = 100
        myLocationManager.startUpdatingLocation()
        myLocationManager.requestAlwaysAuthorization()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        manager.barcodeCommodity(barcode!, callBack: { barSerch in
            //elf.barcode = barcode
            self.pNameLabel.text = barSerch.cName
            self.comImageView.image = barSerch.photo
            }
        )
        yls.loadData()
        //if self.barcode == CommodityManager.sheradInstance.commoditys
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.yls.condition.lat = manager.location!.coordinate.latitude
        self.yls.condition.lon =  manager.location!.coordinate.longitude
        yls.loadData(true)
        let loadDataObserver = NSNotificationCenter.defaultCenter().addObserverForName(yls.YLSLoadCompleteNotification, object: nil, queue: nil, usingBlock: { (notification) in
            self.shopListTable.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yls.total
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShopTableViewCell", forIndexPath: indexPath) as! ShopTableViewCell
        //let com = CommodityManager.sheradInstance.commoditys[indexPath.row]
        let i = yls.total
        if i  > indexPath.row {
            cell.shopLabel.text = yls.shops[indexPath.row].name!
            //print(comment)
            return cell
        } else {
            cell.shopLabel.text  = ""
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRow = indexPath.row
        //print(self.selectedRow)
        performSegueWithIdentifier("toMapSubmit", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "toMapSubmit" {
            // 遷移先のViewContollerにセルの情報を渡す
            let cellVC : MapSubmitViewController = segue.destinationViewController as! MapSubmitViewController
            cellVC.lat = yls.shops[self.selectedRow!].lat
            cellVC.lon = yls.shops[self.selectedRow!].lon
            cellVC.pinTitle = yls.shops[self.selectedRow!].name
            cellVC.barcode = self.barcode
            cellVC.pImage = self.comImageView.image
            cellVC.pName = self.pNameLabel.text
        }
    }
    
    
}
