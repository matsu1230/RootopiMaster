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
    
    @IBOutlet weak var selectMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(self.lon)
        //print(self.lat)
        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
