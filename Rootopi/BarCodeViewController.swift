//
//  BarCodeViewController.swift
//  Rootopi
//
//  Created by matsuuradaiki on 2015/11/02.
//  Copyright © 2015年 matsuuradaiki. All rights reserved.
//

import UIKit
import AVFoundation

class BarCodeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    let captureSession = AVCaptureSession();
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?
    var barCodeData: String?
    // 読み取り範囲（0 ~ 1.0の範囲で指定）
    let x: CGFloat = 0.1
    let y: CGFloat = 0.4
    let width: CGFloat = 0.8
    let height: CGFloat = 0.2
    
    @IBOutlet weak var barCodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    // 映像からmetadataを取得した場合に呼び出されるデリゲートメソッド
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        // metadataが複数ある可能性があるためfor文で回す
        for data in metadataObjects{
            if data.type == AVMetadataObjectTypeEAN13Code{
                print("\(data.stringValue)")
                barCodeData = data.stringValue
                self.captureSession.stopRunning()
            }
        }
    }
    
    @IBAction func barCodeButtonTap(sender: UIButton) {
        self.captureSession.startRunning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "toSelect" {
            // 遷移先のViewContollerにセルの情報を渡す
            let vc : SelectViewController = segue.destinationViewController as! SelectViewController
            vc.barcode = self.barCodeData
        }
    }
}
