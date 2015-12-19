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
        self.yls.shops.removeAll()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        let titleImageView: UIImageView? = UIImageView(image: UIImage(named: "logo"))
        navigationItem.titleView = titleImageView


    }
    
    override func viewDidAppear(animated: Bool) {
        // 現在地を取得します
        
        myMap.delegate = self
        print(self.myMap.annotations.count)
        /*if self.myMap.annotations.count > 0 {
            self.myMap.removeAnnotations(self.myMap.annotations)
            
        }else {
            myMap.delegate = self
        }*/
        //loadFlag = 0
        //buttonCounnt = 0
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
        myWindow.alpha = 0.8
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

        
        descriptionImageView1.frame = CGRectMake(0, 30, 30, 30)
        descriptionImageView1.image = UIImage(named: "blueRadius_29x29")
        descriptionTextLabel1.frame = CGRectMake(30, 30, self.view.frame.width - 30, 30)
        descriptionTextLabel1.text = "をタップすると店舗の名前が見られます。"
            
        descriptionImageView2.frame = CGRectMake(0, 70, 30, 30)
        descriptionImageView2.image = UIImage(named: "mapIcon_29x29")
        descriptionTextLabel2.frame = CGRectMake(30, 70, self.view.frame.width - 30, 50)
        descriptionTextLabel2.numberOfLines = 2
        descriptionTextLabel2.text = "をタップすると\n売っている商品の一覧が見られます。"
        
        mapButton.frame = CGRectMake(290, 0, 50, 50)
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
        let myLatDist : CLLocationDistance = 1000
        let myLonDist : CLLocationDistance = 1000
        manager.stopUpdatingLocation()
        self.yls.shops.removeAll()
        yls.loadData(true)
        myLocationManager.stopUpdatingLocation()
        if loadFlag == 0 {
        let loadDataObserver = NSNotificationCenter.defaultCenter().addObserverForName(yls.YLSLoadCompleteNotification, object: nil, queue: nil, usingBlock: { (notification) in
            for var i = 0; i < self.yls.total; i++ {
                let userLoacate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.yls.condition.lat!,  self.yls.condition.lon!)
                let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.yls.shops[i].lat!, self.yls.shops[i].lon!)
                let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(userLoacate, myLatDist, myLonDist)
                let myPin: MKPointAnnotation = MKPointAnnotation()
                let myCircle: MKCircle = MKCircle(centerCoordinate: myCoordinate, radius: CLLocationDistance(20))
                self.myMap.addOverlay(myCircle)
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
        })
            loadFlag = 1
        }else {
            self.myMap.removeAnnotations(self.myMap.annotations)
            //self.yls.shops.removeAll()
            loadFlag = 1
            buttonCounnt = 0
        }
        let userLoacate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.yls.condition.lat!,  self.yls.condition.lon!)
        let userPin  = MKPointAnnotation()
        let userCircle: MKCircle = MKCircle(centerCoordinate: userLoacate, radius: CLLocationDistance(20))
        //self.myMap.addOverlay(userCircle)
        userPin.coordinate = userLoacate
        userPin.title = "現在地"
        self.myMap.addAnnotation(userPin)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Identifier生成.
        let myAnnotationIdentifier: NSString = "myAnnotation"
        myTable.delegate = self
        myTable.dataSource = self

        print(annotation.title)
        // アノテーション生成.
        var myAnnotationView: MKAnnotationView!
        
        if annotation.title! != "現在地" {
        // もしアノテーションがまだインスタンス化されていなかったらインスタンスを生成する.
        if myAnnotationView == nil {
            
            myAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: myAnnotationIdentifier as String)
            
            // アノテーションに画像を追加.
            let myButton = UIButton(frame: CGRectMake(0,0,50,50))
            
            myAnnotationView.tag = buttonCounnt
            myButton.setBackgroundImage(UIImage(named: "buttonLogo"), forState: .Normal)
            //myButton.backgroundColor = UIColor.brownColor()
            myButton.tag = buttonCounnt
            myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchDown)
            myAnnotationView.leftCalloutAccessoryView = myButton
            
            // アノテーションのコールアウトを許可.
            myAnnotationView.canShowCallout = true
        }
        
        self.buttonCounnt += 1
        return myAnnotationView
        }else {
            let mydentifier: NSString = "carennt"
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: mydentifier as String)
            annotationView.image =  UIImage(named: "crrent")
            annotationView.canShowCallout = true
            return annotationView
        }
    }
    
    
    // 位置情報取得失敗時に呼ばれます
    func locationManager(manager: CLLocationManager,didFailWithError error: NSError){
        print("error", terminator: "")
        
        let myLatDist : CLLocationDistance = 1000
        
        let myLonDist : CLLocationDistance = 1000
        yls.condition.lon = 139.5278631193
        yls.condition.lat = 35.614369808364
        yls.loadData(true)
        manager.stopUpdatingLocation()
        myLocationManager.stopUpdatingLocation()
        if loadFlag == 0 {
        let loadDataObserver = NSNotificationCenter.defaultCenter().addObserverForName(yls.YLSLoadCompleteNotification, object: nil, queue: nil, usingBlock: { (notification) in
            //self.buttonCounnt = 0
            for var i = 0; i < self.yls.total; i++ {
                let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.yls.shops[i].lat!, self.yls.shops[i].lon!)
                let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, myLatDist, myLonDist)
                let myPin: MKPointAnnotation = MKPointAnnotation()
                let myCircle: MKCircle = MKCircle(centerCoordinate: myCoordinate, radius: CLLocationDistance(30))
                self.myMap.addOverlay(myCircle)
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
        })
            loadFlag = 1
            //self.annotationFlag = true
        } else {
            //self.myMap.removeAnnotations(self.myMap.annotations)
            loadFlag = 1
            buttonCounnt = 0
        }
        let userLoacate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.yls.condition.lat!,  self.yls.condition.lon!)
        let userPin  = MKPointAnnotation()
        let userCircle: MKCircle = MKCircle(centerCoordinate: userLoacate, radius: CLLocationDistance(20))
        //self.myMap.addOverlay(userCircle)
        userPin.coordinate = userLoacate
        userPin.title = "現在地"
        self.myMap.addAnnotation(userPin)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        // rendererを生成.
        let myCircleView: MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        
        print(overlay.title)
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
        print(yls.shops[tag].name!)
        
            manager.fechComment(yls.shops[tag].name!, callBack: { maps in
                self.array.append(maps)
                self.myTable.reloadData()
            })
        
        myWindow.addSubview(textView)
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
            descriptionView.addSubview(descriptionTextLabel2)

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
    
}
