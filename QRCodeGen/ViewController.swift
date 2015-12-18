//
//  ViewController.swift
//  QRCodeGen
//
//  Created by Мялин Валентин on 12/12/15.
//  Copyright © 2015 MialinVV. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    //@IBOutlet weak var imgQRCode: UIImageView!
    
    var qrcodeImage: CIImage!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var textQR: String?
    let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
  
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        
        
        //   captureDevice.exposurePointOfInterest = focusPoint
        //captureDevice.exposureMode = AVCaptureExposureMode.ContinuousAutoExposure
        do {
            
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            
            // Start video capture
            captureSession?.startRunning()
            
            let gesture = UITapGestureRecognizer(target: self, action: "tap:")
            self.view.addGestureRecognizer(gesture)
            
            
            // Move the message label to the top view
            // view.bringSubviewToFront(messageLabel)
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        captureSession?.startRunning()
        
    }
   

    
    
    
  /*  func generationQR (textQR: String) {
        
        let data = textQR.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        if data != nil {
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            filter!.setValue(data, forKey: "inputMessage")
            filter!.setValue("L", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter!.outputImage
            
            displayQRCodeImage()
        }
            
        else {
            qrcodeImage = nil
        }
    }
    
    func displayQRCodeImage() {
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
        
        imgQRCode.image = UIImage(CIImage: transformedImage)

    }
*/


    func tap(gesture: UITapGestureRecognizer) {
        let tapPoint = gesture.locationInView(self.view)
        let focusPoint = CGPointMake(
            tapPoint.x / self.view.bounds.size.width,
            tapPoint.y / self.view.bounds.size.height)
        performFocusAnimation(tapPoint)
        do {
            try captureDevice.lockForConfiguration()
            if captureDevice.focusPointOfInterestSupported {
                print(focusPoint)
                captureDevice.focusPointOfInterest = focusPoint
                
            }
            if (captureDevice.isFocusModeSupported(.ContinuousAutoFocus)) {
                
                captureDevice.focusMode = AVCaptureFocusMode.AutoFocus
            }
            if captureDevice.exposurePointOfInterestSupported {
                captureDevice.exposurePointOfInterest = focusPoint
                captureDevice.exposureMode = AVCaptureExposureMode.AutoExpose
            }
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        
        captureDevice.unlockForConfiguration()
        
        
    }

    private func performFocusAnimation(point: CGPoint) {
       
        /*let dot = UIView(frame: CGRectMake(0, 0, 88, 88))
        dot.backgroundColor = UIColor.blackColor()
        dot.layer.cornerRadius = 3
        dot.layer.masksToBounds = true
        dot.center = point
        view.addSubview(dot)
        */
        
        var newImgThumb : UIImageView
        newImgThumb = UIImageView(frame:CGRectMake(0, 0, 100, 100))
        newImgThumb.contentMode = .ScaleAspectFit
        newImgThumb.center = point
        newImgThumb.image = UIImage(named: "indicator.png")!
        view.addSubview(newImgThumb)
        
        UIView.animateWithDuration(0.5, animations: { _ in
            newImgThumb.alpha = 0
            }) { _ in
                newImgThumb.removeFromSuperview()
        }
       // view.bringSubviewToFront(dot)
       // view.bringSubviewToFront(newImgThumb)
    }

    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
          //  messageLabel.text = "No barcode/QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
            //        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            //let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj)
            //qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
               
                textQR = metadataObj.stringValue!
                
               // print(textQR!)
              //  generationQR(textQR!)
                
                let myArray = textQR!.componentsSeparatedByString("\n")
                
                if myArray.count == 20 {
                let поїзд = myArray[1]
                let відправлення = myArray[2]
                let призначення = myArray[3]
                let датаЧасВідпр = myArray[4]
                let датаЧасПриб = myArray[5]
                let вагон = myArray[6]
                let місце = myArray[7]
                let прізвищеІмя = myArray[9]
                let вартість = myArray[12]
                let ticketID = myArray[15]
                
                print(поїзд)
                print(відправлення)
                print(призначення)
                print(датаЧасВідпр)
                print(датаЧасПриб)
                print(вагон)
                print(місце)
                print(прізвищеІмя)
                print(вартість)
                print(ticketID)
                
                }
                
                captureSession!.stopRunning()
                
                tabBarController?.selectedIndex = 0
               // captureSession = nil
                //videoPreviewLayer!.removeFromSuperlayer()
             
                          }
        }
    }
    }




