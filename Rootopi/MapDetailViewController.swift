//
//  MapDetailViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/10/23.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit
import MapKit


class MapDetailViewController: UIViewController,CLLocationManagerDelegate {

    var myLocationManager:CLLocationManager!
    var here: (lat: Double, lon: Double)? = nil
    var yls: YahooLocalSearch = YahooLocalSearch()

    @IBOutlet weak var myMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 現在地を取得します
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.distanceFilter = 100
        myLocationManager.startUpdatingLocation()
        myLocationManager.requestAlwaysAuthorization()
    }
    
    override func viewDidAppear(animated: Bool) {
        //print(yls.total)
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
                myPin.coordinate = myCoordinate
                myPin.title = self.yls.shops[i].name!
                self.myMap.setRegion(myRegion, animated: true)
                self.myMap.addAnnotation(myPin)
            }
        })
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
        
        myPin.coordinate = myCoordinate
        
        yls.condition.lon = 37.506804
        yls.condition.lon = 139.930531
        myMap.setRegion(myRegion, animated: true)
        myMap.addAnnotation(myPin)
        
    }
    @IBAction func mapLocationRefresh(sender: AnyObject) {
        myLocationManager.startUpdatingLocation()
    }

}
