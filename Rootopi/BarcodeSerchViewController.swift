//
//  BarcodeSerchViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/12/03.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit
import AVFoundation


class BarcodeSerchViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var serchButton: UIButton!
    
    let captureSession = AVCaptureSession();
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?
    var barCodeData: String?
    // 読み取り範囲
    let x: CGFloat = 0.1
    let y: CGFloat = 0.4
    let width: CGFloat = 0.8
    let height: CGFloat = 0.2
    
    let commodityManager = CommodityManager.sheradInstance.commoditys
    var commArray: Array<Commodity> = []
    var id: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "バーコード検索"
        // カメラがあるか確認し，取得する
        self.captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error : NSError?
        let inputDevice: AVCaptureDeviceInput!
        do {
            inputDevice = try AVCaptureDeviceInput(device: self.captureDevice)
        } catch let error1 as NSError {
            error = error1
            inputDevice = nil
        }
        if let inp = inputDevice {
            self.captureSession.addInput(inp)
        } else {
            print(error)
        }
        
        // カメラからの取得映像を画面全体に表示する
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewLayer?.frame = CGRectMake(58, 95, 259, 185)
        self.view.layer.insertSublayer(self.previewLayer!, atIndex: 0)
        
        // metadata取得に必要な初期設定
        let metaOutput = AVCaptureMetadataOutput();
        metaOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue());
        self.captureSession.addOutput(metaOutput);
        
        // どのmetadataを取得するか設定する
        metaOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code];
        
        // どの範囲を解析するか設定する
        metaOutput.rectOfInterest = CGRectMake(y, 1-x-width, height, width)
        
        // 解析範囲を表すボーダービューを作成する
        let borderView = UIView(frame: CGRectMake(58, 95, 259, 185))
        borderView.layer.borderWidth = 2
        borderView.layer.borderColor = UIColor.redColor().CGColor
        self.view.addSubview(borderView)
        
        // capture session をスタートする
        self.captureSession.startRunning()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        // metadataが複数ある可能性があるためfor文で回す
        for data in metadataObjects{
            if data.type == AVMetadataObjectTypeEAN13Code{
                print("\(data.stringValue)")
                barCodeData = data.stringValue
                self.captureSession.stopRunning()
                for var i = 0; i < commodityManager.count; i++ {
                    if commodityManager[i].barcode == barCodeData {
                        self.id = i
                    }
                }
            }
        }
    }
    
    @IBAction func tapSerch(sender: UIButton) {
        self.captureSession.startRunning()
        self.id = nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if self.id != nil {
            if segue.identifier == "toCommView" {
                let commVC : CommViewController = segue.destinationViewController as! CommViewController
                commVC.id = self.id
            }
        }
    }
    
}
