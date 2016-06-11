//
//  ViewController.swift
//  QRCodeGen
//
//  Created by Мялин Валентин on 12/12/15.
//  Copyright © 2015 MialinVV. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
 //   var qrcodeImage: CIImage!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var textQR: String?
    let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    @IBOutlet weak var flashlight: UIImageView!
    
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code]
    //[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.managedObjectContext
        
        // анимация flashlight
        self.flashlight.transform = CGAffineTransformMakeScale(0.0, 0.0)
        

        super.viewDidLoad()
    }
    
//    deinit {
        // perform the deinitialization
        
  //  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);

        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        if status == AVAuthorizationStatus.Authorized {
            // Show camera
            self.initializationCaptureSession ()
        } else if status == AVAuthorizationStatus.NotDetermined {
            // Request permission
            print("Request permission")

            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (granted) -> Void in
                if granted {
                    // Show camera
                    self.initializationCaptureSession ()
                }
            })
        } else {
            print("нет доступа к камере")
            // User rejected permission. Ask user to switch it on in the Settings app manually
            //open the settings to allow the user to select if they want to allow for location settings.
            
            let alert = UIAlertController(title: "Невозможно получить доступ к камере", message: "Сканеру требуется доступ к вашей камере для сканирования кодов. Перейдите в настройки приватности вашего устройства для включения камеры.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.Default, handler:nil))
            alert.addAction(UIAlertAction(title: "Настройки", style: UIAlertActionStyle.Default, handler: {
                (alert: UIAlertAction!) in
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            }))
                
            self.presentViewController(alert, animated: true, completion: nil)
            
            
            
            
        }
    }
    override func viewDidAppear(animated: Bool) {
        
        // анимация flashlight
        UIView.animateWithDuration(0.4, delay: 0, options: [], animations: {self.flashlight.transform = CGAffineTransformIdentity}, completion: nil)    }
   

    func initializationCaptureSession () {
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
            view.bringSubviewToFront(flashlight)
            
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }

    func deleteCaptureSession () {
        
        if captureSession != nil {
            self.captureSession!.stopRunning()
            captureSession = nil
        }
        
    
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
                //print(focusPoint)
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
       
        var newImgThumb : UIImageView
        newImgThumb = UIImageView(frame:CGRectMake(0, 0, 100, 100))
        newImgThumb.contentMode = .ScaleAspectFit
        newImgThumb.center = point
        newImgThumb.image = UIImage(named: "indicator")!
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
          print("No barcode/QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
            
            if metadataObj.stringValue != nil {
                textQR = metadataObj.stringValue!
                
                if let textQR = textQR {
                 //   print(textQR)
                    
                    let arrayScanCode = textQR.componentsSeparatedByString("\n")
                   
                    if arrayScanCode.count == 20 /*&& arrayScanCode[15] == arrayScanCode[19] */{
                        
                        // create an instance of our managedObjectContext
                        let context = DataController().managedObjectContext
                        let request = NSFetchRequest(entityName: "Tickets")
                        
                        // we set up our entity by selecting the entity and context that we're targeting
                        let entity = NSEntityDescription.insertNewObjectForEntityForName("Tickets", inManagedObjectContext: context) as! Tickets

                        let predicate = NSPredicate(format: "ticketID == %@", arrayScanCode[15])
                        request.predicate = predicate
                        do {
                            let results = try context.executeFetchRequest(request) as! [Tickets]
                            
                            
                            if (results.count > 0) {
                               
                                self.deleteCaptureSession ()
                                alertCaptureSession("Билет уже добавлен")
                                    
                                
                            } else {
                                print("билета нету в Core Data, добавляем")
                                
                                deleteCaptureSession ()
                                videoPreviewLayer!.removeFromSuperlayer()
                                
                                entity.setValue(textQR, forKey: "stringTicket") // сохраняем всю строку, для создания QR кода
                                
                                
                                entity.setValue(arrayScanCode[1], forKey: "train") // поїзд
                                entity.setValue(arrayScanCode[2], forKey: "departure") // відправлення
                                entity.setValue(arrayScanCode[3], forKey: "destination") // призначення
                                entity.setValue(stringToDate(arrayScanCode[4]), forKey: "dateTimeDep") // датаЧасВідпр
                                entity.setValue(stringToDate(arrayScanCode[5]), forKey: "dateTimeDes") // датаЧасПриб
                                entity.setValue(arrayScanCode[6], forKey: "coach") // вагон
                                entity.setValue(arrayScanCode[7], forKey: "seat") // місце
                                entity.setValue(arrayScanCode[9], forKey: "surnameAndName") // прізвищеІмя
                                entity.setValue(NSString(string: arrayScanCode[12]).floatValue, forKey: "cost") // вартість
                                entity.setValue(arrayScanCode[15], forKey: "ticketID")
                                
                               
                                
                                // we save our entity
                                do {
                                    try context.save()
                                } catch {
                                    fatalError("Failure to save context: \(error)")
                                }
                                
                                // перейти на первый tab
                                tabBarController?.selectedIndex = 0
                                
                            }
                        } catch let error as NSError {
                            // failure
                            print("Fetch failed: \(error.localizedDescription)")
                        }

                        
                    }
                    else{
                        if arrayScanCode.count == 1 && arrayScanCode[0].characters.count == 19 {
                            
                             self.alertCaptureSession("возможно шрих код")
                            print(arrayScanCode[0]) //19
                        }
                        else {
                             self.alertCaptureSession("в QR code нету билета")
                        }
                       
                    }
                }
              //  captureSession!.stopRunning()
              //  videoPreviewLayer!.removeFromSuperlayer()
                
                // перейти на первый tab
             //   tabBarController?.selectedIndex = 0
             
            }
        }
        
    else{
    print("del")
    deleteCaptureSession ()
    videoPreviewLayer!.removeFromSuperlayer()
    }
    }


    
    func clearCoreData(entity:String) {
        let moc = DataController().managedObjectContext
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName(entity, inManagedObjectContext: moc)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try moc.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    moc.deleteObject(result)
                }
                
                try moc.save()
            }
        } catch {
         print("failed to clear core data")
        }
    }
    
    func stringToDate (stringData: String) -> NSDate  {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat  = "dd.MM HH:mm" //21.11 20:01
        dateFormatter.timeZone = NSTimeZone(name: "Europe/Kiev")
        dateFormatter.defaultDate = NSDate()
        let date = dateFormatter.dateFromString(stringData)
        
        let dayComponenet = NSDateComponents()
        dayComponenet.day = 30
        
        let theCalendar = NSCalendar.currentCalendar()
        let nextDate = theCalendar.dateByAddingComponents(dayComponenet, toDate: NSDate(), options: [])
       // print(nextDate)
        
        if date!.compare(nextDate!) == .OrderedDescending {
            // Текущая дата больше конечной даты
            
            let dayComponenet = NSDateComponents()
            dayComponenet.year = -1
            
            let theCalendar = NSCalendar.currentCalendar()
            dateFormatter.defaultDate = theCalendar.dateByAddingComponents(dayComponenet, toDate: NSDate(), options: [])
       // print(dateFormatter.dateFromString(stringData)!)
            return dateFormatter.dateFromString(stringData)!
        }
        else {
            return date!
        }

       /* let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat  = "dd.MM HH:mm" //21.11 20:01
        dateFormatter.timeZone = NSTimeZone(name: "Europe/Kiev")
        let dateMaker = NSDateFormatter()
            dateMaker.dateFormat = "yyyy/MM/dd HH:mm:ss"
        //    let start = dateMaker.dateFromString("2016/01/01 08:00:00")!
        //    let end = dateMaker.dateFromString("2016/02/15 16:30:00")!
        
        let dayComponenet = NSDateComponents()
        dayComponenet.day = 31
        
        let theCalendar = NSCalendar.currentCalendar()
        let nextDate = theCalendar.dateByAddingComponents(dayComponenet, toDate: NSDate(), options: [])
        
        if NSDate().compare(nextDate!) == NSComparisonResult.OrderedDescending {
            
        }
        
        
        
        //dateFormatter.defaultDate = dateMaker.dateFromString("2001/01/01 00:00:00")
        let date = dateFormatter.dateFromString(stringData)
        return date!
        //dateFormatter.dateFormat = "dd-MM HH:mm"
       // return dateFormatter.stringFromDate(date!)
*/
    }
    
    func alertCaptureSession(messageText: String)
    {
            let alertController = UIAlertController(title: title, message: messageText, preferredStyle:UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
                { action -> Void in
                    // Put your code here
                    self.initializationCaptureSession()
                })
            //self.captureSession!.startRunning()
            self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func dateStart(end: NSDate ) -> Bool {
        //    var dateComparisionResult:NSComparisonResult = currentDate.compare(end)
        if NSDate().compare(end) == NSComparisonResult.OrderedDescending {
            
            return true
        }
        return false
    }
    

    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        deleteCaptureSession ()
        videoPreviewLayer!.removeFromSuperlayer()
        
        flashlight.image = UIImage(named: "flashlightOff")
        
        // анимация flashlight
        self.flashlight.transform = CGAffineTransformMakeScale(0.0, 0.0)
    }
    
    @IBAction func flashlightAction(sender: AnyObject) {
        toggleFlash(0.5)
    }
    
    
    func toggleFlash(input: Float) {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                //device.torchMode = AVCaptureTorchMode.On
                //try device.setTorchModeOnWithLevel(input)
                
                if (device.torchMode == AVCaptureTorchMode.On) {
                    device.torchMode = AVCaptureTorchMode.Off
                    flashlight.image = UIImage(named: "flashlightOff")
                } else {
                    do {
                        try device.setTorchModeOnWithLevel(input)
                        flashlight.image = UIImage(named: "flashlightOn")
                    } catch {
                        print(error)
                    }
                }
                
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
}



