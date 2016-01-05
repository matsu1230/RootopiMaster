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
    let commodity = CommodityManager.sheradInstance
    
    @IBOutlet weak var myMap: MKMapView!
    
    private var myWindow: UIWindow!
    private var descriptionWindow: UIWindow!
    private var descriptionView: UIView = UIView()
    private var descriptionFlag  = false
    private var textView: UITextField!
    let myView: UIView = UIView()
    private var myWindowButton: UIButton!
    private var mapButton : UIButton = UIButton(type: .InfoDark)
    private var descriptionButton: UIButton = UIButton(frame:  CGRectMake(0, 0, 25, 25))
    private var descriptionTextLabel1: UILabel = UILabel()
    private var descriptionImageView1: UIImageView = UIImageView()
    private var descriptionTextLabel2: UILabel = UILabel()
    private var descriptionImageView2: UIImageView = UIImageView()


    let myTable: UITableView = UITableView()
    
    let manager = MapManeger()
    var buttonCounnt = 0
    var selectedRow : Int?
    var id : Int?
    var loadFlag = 0
    var annotationFlag = false
    var array: Array<Maps> = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //self.yls.shops.removeAll()

        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        //self.navigationController?.title = "地図"
        myMap.delegate = self
        self.buttonCounnt = 0
        self.loadFlag = 0
        self.array.removeAll()
        self.yls.shops.removeAll()
        self.myMap.removeAnnotations(self.myMap.annotations)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        // 現在地を取得します
        //myMap.removeAnnotations(myMap.annotations)
        self.buttonCounnt = 0
        //print(yls.shops)
        //self.yls.shops.removeAll()
        self.yls.condition.lat = nil
        self.yls.condition.lon = nil
        //print(self.myMap.annotations)
       // print(self.buttonCounnt)

        /*else {
            myMap.delegate = self
        }*/
        //loadFlag = 0
        descriptionWindow = UIWindow()
        myWindow = UIWindow()
        myWindowButton = UIButton()
        textView = UITextField()
        
        
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
        myWindow.frame = CGRectMake(0, 150, self.view.frame.width, 330)
        myTable.frame = CGRectMake(0, 30, view.frame.width, 250)
        textView.frame = CGRectMake(30, 0, view.frame.width, 20)
        textView.text = "この店舗に売っている商品一覧"
        myWindow.layer.position = CGPointMake(self.view.frame.width/2, 250)
        myWindow.alpha = 1
        myWindow.layer.cornerRadius = 20
        
        
        if descriptionFlag == false {
        descriptionButton.backgroundColor = UIColor.redColor()
        descriptionButton.tag = 0
        descriptionButton.addTarget(self, action: "onClickMapBtton:", forControlEvents: .TouchDown)
        descriptionButton.layer.cornerRadius = 10
        descriptionButton.setTitle("×", forState: .Normal)
        descriptionButton.titleLabel!.font = UIFont.systemFontOfSize(30)
        descriptionButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)

            

        
        descriptionView.frame = CGRectMake(0, 70, self.view.frame.width, 120)
        descriptionView.backgroundColor = UIColor.whiteColor()
            
        descriptionView.layer.cornerRadius = 20

        
        descriptionImageView1.frame = CGRectMake(10, 30, 30, 30)
        descriptionImageView1.image = UIImage(named: "blueRadius_29x29")
        descriptionTextLabel1.frame = CGRectMake(40, 30, self.view.frame.width - 40, 30)
        descriptionTextLabel1.text = "をタップすると店舗の名前が見られます。"
            
        descriptionImageView2.frame = CGRectMake(10, 70, 30, 30)
        descriptionImageView2.image = UIImage(named: "mapIcon_29x29")
        descriptionTextLabel2.frame = CGRectMake(40, 70, self.view.frame.width - 40, 50)
        descriptionTextLabel2.numberOfLines = 2
        descriptionTextLabel2.text = "をタップすると\n売っている商品の一覧が見られます。"
        
        mapButton.frame = CGRectMake(200, 0, 50, 50)
        mapButton.layer.position = CGPoint(x: self.view.frame.width - 50, y: 10)
        mapButton.tag = 1
        mapButton.addTarget(self, action: "onClickMapBtton:", forControlEvents: .TouchDown)
        }
        
        
        
        descriptionView.addSubview(descriptionButton)
        descriptionView.addSubview(descriptionImageView1)
        descriptionView.addSubview(descriptionTextLabel1)
        descriptionView.addSubview(descriptionImageView2)
        descriptionView.addSubview(descriptionTextLabel2)
        
        
        myMap.addSubview(mapButton)
        self.view.addSubview(descriptionView)
        
        //WindowButton
        myWindowButton.frame = CGRectMake(0, 0, 100, 30)
        myWindowButton.backgroundColor = UIColor.orangeColor()
        myWindowButton.setTitle("閉じる", forState: .Normal)
        myWindowButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        myWindowButton.layer.masksToBounds = true
        myWindowButton.layer.cornerRadius = 10.0
        myWindowButton.addTarget(self, action: "onClick:", forControlEvents: .TouchUpInside)
        myWindowButton.layer.position = CGPointMake(self.myWindow.frame.width/2, 300)
    }
    
    // 位置情報取得成功時に呼ばれます
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.yls.condition.lat = manager.location!.coordinate.latitude
        self.yls.condition.lon =  manager.location!.coordinate.longitude
        //self.myMap.setCenterCoordinate(self.myMap.userLocation.coordinate, animated: true)
        let myLatDist : CLLocationDistance = 800
        let myLonDist : CLLocationDistance = 800
        manager.stopUpdatingLocation()
        myLocationManager.stopUpdatingLocation()
        yls.loadData(true)
        if self.loadFlag == 0 {
        let loadDataObserver = NSNotificationCenter.defaultCenter().addObserverForName(yls.YLSLoadCompleteNotification, object: nil, queue: nil, usingBlock: { (notification) in
            for var i = 0; i < self.yls.total; i++ {
                let userLoacate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.yls.condition.lat!,  self.yls.condition.lon!)
                let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.yls.shops[i].lat!, self.yls.shops[i].lon!)
                let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(userLoacate, myLatDist, myLonDist)
                let myPin: MKPointAnnotation = MKPointAnnotation()
                myPin.coordinate = myCoordinate
                if self.yls.shops[i].name?.utf16.count > 13 {
                    let shopName = self.yls.shops[i].name! as NSString
                    myPin.title = shopName.substringToIndex(13)
                    myPin.subtitle = shopName.substringFromIndex(13)
                }else {
                    myPin.title = self.yls.shops[i].name!
                }
                self.myMap.setRegion(myRegion, animated: true)
                self.myMap.addAnnotation(myPin)
            }
            self.loadFlag = 1
        })
        }
        if self.loadFlag == 0 {
        let userLoacate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.yls.condition.lat!,  self.yls.condition.lon!)
        let myCircle: MKCircle = MKCircle(centerCoordinate: userLoacate, radius: CLLocationDistance(20))
        self.myMap.addOverlay(myCircle)
        let userPin  = MKPointAnnotation()
        userPin.coordinate = userLoacate
        userPin.title = "現在地"
        self.myMap.addAnnotation(userPin)
        }
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Identifier生成.
        let myAnnotationIdentifier: NSString = "myAnnotation"
        myTable.delegate = self
        myTable.dataSource = self
        //print(annotation.title)
        let title = annotation.title
        var subtitle = annotation.subtitle
        print(title)
        print(subtitle)
        // アノテーション生成.
        var myAnnotationView: MKAnnotationView!
        if annotation.title! != "現在地" {
            // もしアノテーションがまだインスタンス化されていなかったらインスタンスを生成する.
            if myAnnotationView == nil {
                myAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: myAnnotationIdentifier as String)
                
                // アノテーションに画像を追加.
                let myButton = UIButton(frame: CGRectMake(0,0,50,50))
                //myButton.tag = 0
                myAnnotationView.tag = self.buttonCounnt
                myButton.setBackgroundImage(UIImage(named: "buttonLogo"), forState: .Normal)
                //print(myButton.tag)
                //print(self.buttonCounnt)
                myButton.tag = self.buttonCounnt
                //print(myButton.tag)
                myButton.setTitle("\(title)", forState: .Normal)
                myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchDown)
                myAnnotationView.leftCalloutAccessoryView = myButton
                myAnnotationView.image =  UIImage(named: "crrent")
                // アノテーションのコールアウトを許可.
                myAnnotationView.canShowCallout = true
                
                self.buttonCounnt += 1
            }
            
            return myAnnotationView
        }else {
            let mydentifier: NSString = "carennt"
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: mydentifier as String)
            //annotationView.image =  UIImage(named: "crrent")
            annotationView.canShowCallout = true
            return annotationView
        }
    }
    
    
    // 位置情報取得失敗時に呼ばれます
    func locationManager(manager: CLLocationManager,didFailWithError error: NSError){
        print("error", terminator: "")
        //self.myMap.setCenterCoordinate(self.myMap.userLocation.coordinate, animated: true)
        let myLatDist : CLLocationDistance = 1000
        let myLonDist : CLLocationDistance = 1000
        yls.condition.lon = 139.751891
        yls.condition.lat = 35.70564
        manager.stopUpdatingLocation()
        myLocationManager.stopUpdatingLocation()
        print("あああ")
        yls.loadData(true)
        print(self.yls.total)
        //self.myMap.removeAnnotations(self.myMap.annotations)
        if self.loadFlag == 0 {
            let loadDataObserver = NSNotificationCenter.defaultCenter().addObserverForName(yls.YLSLoadCompleteNotification, object: nil, queue: nil, usingBlock: { (notification) in
                for var i = 0; i < self.yls.total; i++ {
                    let userLoacate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.yls.condition.lat!,  self.yls.condition.lon!)
                    print(i)
                    let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.yls.shops[i].lat!, self.yls.shops[i].lon!)
                    let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(userLoacate, myLatDist, myLonDist)
                    let myPin: MKPointAnnotation = MKPointAnnotation()
                    myPin.coordinate = myCoordinate
                    if self.yls.shops[i].name?.utf16.count > 13 {
                        let shopName = self.yls.shops[i].name! as NSString
                        myPin.title = shopName.substringToIndex(13)
                        myPin.subtitle = shopName.substringFromIndex(13)
                    }else {
                        myPin.title = self.yls.shops[i].name!
                    }
                    self.myMap.setRegion(myRegion, animated: true)
                    self.myMap.addAnnotation(myPin)
                    //self.buttonCounnt += 1
                }
                //self.buttonCounnt += 1
                self.loadFlag = 1
            })
        }
        if self.loadFlag == 0 {
        let userLoacate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.yls.condition.lat!,  self.yls.condition.lon!)
        let myCircle: MKCircle = MKCircle(centerCoordinate: userLoacate, radius: CLLocationDistance(20))
        self.myMap.addOverlay(myCircle)
        let userPin  = MKPointAnnotation()
        userPin.coordinate = userLoacate
        userPin.title = "現在地"
        self.myMap.addAnnotation(userPin)
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        // rendererを生成.
        let myCircleView: MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        
        //print(overlay.title)
        // 円の内部を青色で塗りつぶす.
        myCircleView.fillColor = UIColor.blueColor()
        
        // 円を透過させる.
        //myCircleView.alpha = 0.5
        
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
        //print(yls.shops[tag].name!)
        
            manager.fechComment(yls.shops[tag].name!, callBack: { maps in
                self.array.append(maps)
                self.myTable.reloadData()
            })
        
        myWindow.addSubview(textView)
        myWindow.addSubview(myTable)
        
    }
    
    
    internal func onClickMyButton(sender: UIButton) {
        print(sender.tag)
        //print(sender.titl)
        makeMyWindow(sender.tag)
    }
    
    internal func onClick(sender: UIButton) {
        myWindow.hidden = true
        self.array.removeAll()
        self.myTable.reloadData()
    }
    
    internal func onClickMapBtton(sender: UIButton) {
        if sender.tag == 0 {
            descriptionView.hidden = true
            descriptionFlag = true
            var subviews = self.descriptionView.subviews
            for subview in subviews {
                subview.removeFromSuperview()
            }
        } else if sender.tag == 1 {
            descriptionView.hidden = false
            descriptionFlag = false
            descriptionView.addSubview(descriptionButton)
            descriptionView.addSubview(descriptionTextLabel1)
            descriptionView.addSubview(descriptionImageView1)
            descriptionView.addSubview(descriptionTextLabel2)
            descriptionView.addSubview(descriptionImageView2)

        }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRow = indexPath.row
        for var i = 0; i < commodity.commoditys.count; i++ {
            if (self.array[self.selectedRow!].pName == commodity.commoditys[i].cName) {
                self.id = i
            }
        }
        performSegueWithIdentifier("fromMap", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromMap" {
            myWindow.hidden = true
            let comVC : CommViewController = segue.destinationViewController as! CommViewController
            self.array.removeAll()
            comVC.id = self.id
            //self.buttonCounnt = 0
        }
    }
    
    @IBAction func mapLocationRefresh(sender: AnyObject) {
        myLocationManager.startUpdatingLocation()
    }
    
   deinit {
        //self.myMap.removeAnnotations(self.myMap.annotations)
        //self.buttonCounnt = 0
        print("ああああああああああああああああああ")
    }
}
