//
//  MapSubmitViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/11/03.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit
import MapKit

class MapSubmitViewController: UIViewController {
    
    var lon : Double?
    var lat : Double?
    var pinTitle : String?
    var barcode :String?
    var pName : String?
    var pImage : UIImage?
    
    @IBOutlet weak var shopLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var selectMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleImageView: UIImageView? = UIImageView(image: UIImage(named: "logo"))
        self.navigationItem.titleView = titleImageView
        //print(self.lon)
        //print(self.lat)
        // Do any additional setup after loading the
        self.shopLabel.text = self.pinTitle!
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        let preiceLon = self.lon!
        let preiceLat = self.lat!
        let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(preiceLat, preiceLon)
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, 200, 200)
        let myPin: MKPointAnnotation = MKPointAnnotation()
        myPin.coordinate = myCoordinate
        myPin.title = self.pinTitle
        self.selectMap.setRegion(myRegion, animated: false)
        self.selectMap.addAnnotation(myPin)
    }
    
    @IBAction func submitButton(sender: UIButton) {
        let data : NSData = UIImagePNGRepresentation(self.pImage!)!
        let map = MapSave(lat: self.lat!, lon: self.lon!,name: self.pinTitle!, barcode:  self.barcode!, pName: self.pName!, pImage: data)
        map.save()
    }
    
    
    
}
