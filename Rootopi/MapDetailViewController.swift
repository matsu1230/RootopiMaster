//
//  MapDetailViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/23.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit
import MapKit


class MapDetailViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate,UITableViewDataSource, UITableViewDelegate {
    
    var myLocationManager:CLLocationManager!
    var here: (lat: Double, lon: Double)? = nil
    var yls: YahooLocalSearch = YahooLocalSearch()
    
    @IBOutlet weak var myMap: MKMapView!
    
    private var myWindow: UIWindow!
    let myView: UIView = UIView()
    private var myWindowButton: UIButton!
    let myTable: UITableView = UITableView()
    
    let manager = MapManeger()
    var buttonCounnt = 0

    var array: Array<Maps> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        let titleImageView: UIImageView? = UIImageView(image: UIImage(named: "logo"))
        navigationItem.titleView = titleImageView

        // 現在地を取得します

        myMap.delegate = self
        
        myWindow = UIWindow()
        myWindowButton = UIButton()

        
        myTable.registerNib(UINib(nibName: "ShopTableViewCell", bundle: nil), forCellReuseIdentifier: "ShopTableViewCell")

        //myMap.d
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.distanceFilter = 100
        myLocationManager.startUpdatingLocation()
        myLocationManager.requestAlwaysAuthorization()

        
        //window
        myWindow.backgroundColor = UIColor.whiteColor()
        myWindow.frame = CGRectMake(0, 150, self.view.frame.width, 300)
        myTable.frame = CGRectMake(0, 0, view.frame.width, 250)
        myWindow.layer.position = CGPointMake(self.view.frame.width/2, 250)
        myWindow.alpha = 0.8
        myWindow.layer.cornerRadius = 20
        
        //WindowButton
        myWindowButton.frame = CGRectMake(0, 0, 100, 50)
        myWindowButton.backgroundColor = UIColor.orangeColor()
        myWindowButton.setTitle("Close", forState: .Normal)
        myWindowButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        myWindowButton.layer.masksToBounds = true
        myWindowButton.layer.cornerRadius = 20.0
        myWindowButton.addTarget(self, action: "onClick:", forControlEvents: .TouchUpInside)
        myWindowButton.layer.position = CGPointMake(self.myWindow.frame.width/2, 280)

    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    // 位置情報取得成功時に呼ばれます
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.yls.condition.lat = manager.location!.coordinate.latitude
        self.yls.condition.lon =  manager.location!.coordinate.longitude
        let myLatDist : CLLocationDistance = 1000
        let myLonDist : CLLocationDistance = 1000
        manager.stopUpdatingLocation()
        yls.loadData(true)
        let loadDataObserver = NSNotificationCenter.defaultCenter().addObserverForName(yls.YLSLoadCompleteNotification, object: nil, queue: nil, usingBlock: { (notification) in
            //print(self.yls.shops[0].lon)
            for var i = 0; i < self.yls.total; i++ {
                let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.yls.shops[i].lat!, self.yls.shops[i].lon!)
                let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, myLatDist, myLonDist)
                let myPin: MKPointAnnotation = MKPointAnnotation()
                let myCircle: MKCircle = MKCircle(centerCoordinate: myCoordinate, radius: CLLocationDistance(50))
                self.myMap.addOverlay(myCircle)
                myPin.coordinate = myCoordinate
                myPin.title = self.yls.shops[i].name!
                self.myMap.setRegion(myRegion, animated: true)
                self.myMap.addAnnotation(myPin)
            }
            //self.myButton.tag = self.buttonCounnt + 1
            //self.buttonCounnt += 1
        })
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Identifier生成.
        let myAnnotationIdentifier: NSString = "myAnnotation"
        
        myTable.delegate = self
        myTable.dataSource = self

        // アノテーション生成.
        var myAnnotationView: MKAnnotationView!
        
        // もしアノテーションがまだインスタンス化されていなかったらインスタンスを生成する.
        if myAnnotationView == nil {
            
            myAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: myAnnotationIdentifier as String)
            
            // アノテーションに画像を追加.
            //print(myAnnotationView.annotation?)
            //myAnnotationView.annotation.
            let myButton = UIButton(frame: CGRectMake(0,0,50,50))
            
            myAnnotationView.tag = buttonCounnt
            myButton.backgroundColor = UIColor.brownColor()
            myButton.tag = buttonCounnt
            myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchDown)
            myAnnotationView.leftCalloutAccessoryView = myButton
            
            // アノテーションのコールアウトを許可.
            myAnnotationView.canShowCallout = true
        }
        
        buttonCounnt += 1
        return myAnnotationView
    }
    
    
    // 位置情報取得失敗時に呼ばれます
    func locationManager(manager: CLLocationManager,didFailWithError error: NSError){
        print("error", terminator: "")
        
        let myLat: CLLocationDegrees = 37.506804
        
        let myLon: CLLocationDegrees = 139.930531
        
        let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLat, myLon)
        
        let myLatDist : CLLocationDistance = 100
        
        let myLonDist : CLLocationDistance = 100
        
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, myLatDist, myLonDist);
        let myPin: MKPointAnnotation = MKPointAnnotation()
        
        
        let myCircle: MKCircle = MKCircle(centerCoordinate: myCoordinate, radius: CLLocationDistance(5))
        myMap.addOverlay(myCircle)
        
        myPin.coordinate = myCoordinate
        myPin.title = "aaaaa"
        yls.condition.lon = 37.506804
        yls.condition.lon = 139.930531
        myMap.setRegion(myRegion, animated: true)
        myMap.addAnnotation(myPin)
        
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        // rendererを生成.
        let myCircleView: MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        
        // 円の内部を青色で塗りつぶす.
        myCircleView.fillColor = UIColor.blueColor()
        
        // 円を透過させる.
        myCircleView.alpha = 0.5
        
        // 円周の線の太さ.
        myCircleView.lineWidth = 0.5
        
        return myCircleView
    }

    
    internal func makeMyWindow(tag: Int){
        
        // 背景を白に設定する.
        
        // myWindowをkeyWindowにする.
        myWindow.makeKeyWindow()
        
        //myMap.annotations.
        // ボタンを作成する.
        self.myWindow.addSubview(myWindowButton)
        
        // windowを表示する.
        self.myWindow.makeKeyAndVisible()
        
        
            manager.fechComment(yls.shops[tag].name!, callBack: { maps in
                self.array.append(maps)
                self.myTable.reloadData()
            })
        
        myWindow.addSubview(myTable)
        

    }
    
    
    internal func onClickMyButton(sender: UIButton) {
        print(sender.tag)
        makeMyWindow(sender.tag)
    }
    
    internal func onClick(sender: UIButton) {
        myWindow.hidden = true
        self.array.removeAll()
        self.myTable.reloadData()
    }
    //Table
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShopTableViewCell", forIndexPath: indexPath) as! ShopTableViewCell
        
        cell.shopLabel.text = self.array[indexPath.row].pName
        cell.shopImage.image = self.array[indexPath.row].pImage
        return cell

    }
    
    
    @IBAction func mapLocationRefresh(sender: AnyObject) {
        myLocationManager.startUpdatingLocation()
    }
    
}
