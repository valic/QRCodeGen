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
    let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    @IBOutlet weak var flashlight: UIImageView!
    
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code]
    //[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.managedObjectContext
        
        // анимация flashlight
        self.flashlight.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        

        super.viewDidLoad()
    }
    
//    deinit {
        // perform the deinitialization
        
  //  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);

        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if status == AVAuthorizationStatus.authorized {
            // Show camera
            self.initializationCaptureSession ()
        } else if status == AVAuthorizationStatus.notDetermined {
            // Request permission
            print("Request permission")

            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) -> Void in
                if granted {
                    // Show camera
                    self.initializationCaptureSession ()
                }
            })
        } else {
            print("нет доступа к камере")
            // User rejected permission. Ask user to switch it on in the Settings app manually
            //open the settings to allow the user to select if they want to allow for location settings.
            
            let alert = UIAlertController(title: "Невозможно получить доступ к камере", message: "Сканеру требуется доступ к вашей камере для сканирования кодов. Перейдите в настройки приватности вашего устройства для включения камеры.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.default, handler:nil))
            alert.addAction(UIAlertAction(title: "Настройки", style: UIAlertActionStyle.default, handler: {
                (alert: UIAlertAction!) in
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            }))
                
            self.present(alert, animated: true, completion: nil)
            
            
            
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
        // анимация flashlight
        UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {self.flashlight.transform = CGAffineTransform.identity}, completion: nil)    }
   

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
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            
            // Start video capture
            captureSession?.startRunning()
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tap(_:)))
            self.view.addGestureRecognizer(gesture)
            

            // Move the message label to the top view
            // view.bringSubviewToFront(messageLabel)
            view.bringSubview(toFront: flashlight)
            
            
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


    func tap(_ gesture: UITapGestureRecognizer) {
        let tapPoint = gesture.location(in: self.view)
        let focusPoint = CGPoint(
            x: tapPoint.x / self.view.bounds.size.width,
            y: tapPoint.y / self.view.bounds.size.height)
      
        performFocusAnimation(tapPoint)
        do {
            try captureDevice?.lockForConfiguration()
            if (captureDevice?.isFocusPointOfInterestSupported)! {
                //print(focusPoint)
                captureDevice?.focusPointOfInterest = focusPoint
                
            }
            if (captureDevice?.isFocusModeSupported(.continuousAutoFocus))! {
                
                captureDevice?.focusMode = AVCaptureFocusMode.autoFocus
            }
            if (captureDevice?.isExposurePointOfInterestSupported)! {
                captureDevice?.exposurePointOfInterest = focusPoint
                captureDevice?.exposureMode = AVCaptureExposureMode.autoExpose
            }
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        
        captureDevice?.unlockForConfiguration()
        
        
    }

    fileprivate func performFocusAnimation(_ point: CGPoint) {
       
        var newImgThumb : UIImageView
        newImgThumb = UIImageView(frame:CGRect(x: 0, y: 0, width: 100, height: 100))
        newImgThumb.contentMode = .scaleAspectFit
        newImgThumb.center = point
        newImgThumb.image = UIImage(named: "indicator")!
        view.addSubview(newImgThumb)
        
        UIView.animate(withDuration: 0.5, animations: { _ in
            newImgThumb.alpha = 0
            }, completion: { _ in
                newImgThumb.removeFromSuperview()
        }) 
       // view.bringSubviewToFront(dot)
       // view.bringSubviewToFront(newImgThumb)
    }

    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
  
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
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
                    
                    let arrayScanCode = textQR.components(separatedBy: "\n")
                   
                    if arrayScanCode.count == 20 /*&& arrayScanCode[15] == arrayScanCode[19] */{
                        
                        // create an instance of our managedObjectContext
                        let context = DataController().managedObjectContext
                        let request = NSFetchRequest(entityName: "Tickets")
                        
                        // we set up our entity by selecting the entity and context that we're targeting
                        let entity = NSEntityDescription.insertNewObject(forEntityName: "Tickets", into: context) as! Tickets

                        let predicate = NSPredicate(format: "ticketID == %@", arrayScanCode[15])
                        request.predicate = predicate
                        do {
                            let results = try context.fetch(request) as! [Tickets]
                            
                            
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


    
    func clearCoreData(_ entity:String) {
        let moc = DataController().managedObjectContext
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entity, in: moc)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try moc.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    moc.delete(result)
                }
                
                try moc.save()
            }
        } catch {
         print("failed to clear core data")
        }
    }
    
    func stringToDate (_ stringData: String) -> Date  {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat  = "dd.MM HH:mm" //21.11 20:01
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Kiev")
        dateFormatter.defaultDate = Date()
        let date = dateFormatter.date(from: stringData)
        
        var dayComponenet = DateComponents()
        dayComponenet.day = 30
        
        let theCalendar = Calendar.current
        let nextDate = (theCalendar as NSCalendar).date(byAdding: dayComponenet, to: Date(), options: [])
       // print(nextDate)
        
        if date!.compare(nextDate!) == .orderedDescending {
            // Текущая дата больше конечной даты
            
            var dayComponenet = DateComponents()
            dayComponenet.year = -1
            
            let theCalendar = Calendar.current
            dateFormatter.defaultDate = (theCalendar as NSCalendar).date(byAdding: dayComponenet, to: Date(), options: [])
       // print(dateFormatter.dateFromString(stringData)!)
            return dateFormatter.date(from: stringData)!
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
    
    func alertCaptureSession(_ messageText: String)
    {
            let alertController = UIAlertController(title: title, message: messageText, preferredStyle:UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                { action -> Void in
                    // Put your code here
                    self.initializationCaptureSession()
                })
            //self.captureSession!.startRunning()
            self.present(alertController, animated: true, completion: nil)
    }
    
    func dateStart(_ end: Date ) -> Bool {
        //    var dateComparisionResult:NSComparisonResult = currentDate.compare(end)
        if Date().compare(end) == ComparisonResult.orderedDescending {
            
            return true
        }
        return false
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        deleteCaptureSession ()
        videoPreviewLayer!.removeFromSuperlayer()
        
        flashlight.image = UIImage(named: "flashlightOff")
        
        // анимация flashlight
        self.flashlight.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }
    
    @IBAction func flashlightAction(_ sender: AnyObject) {
        toggleFlash(0.5)
    }
    
    
    func toggleFlash(_ input: Float) {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if (device?.hasTorch)! {
            do {
                try device?.lockForConfiguration()
                //device.torchMode = AVCaptureTorchMode.On
                //try device.setTorchModeOnWithLevel(input)
                
                if (device?.torchMode == AVCaptureTorchMode.on) {
                    device?.torchMode = AVCaptureTorchMode.off
                    flashlight.image = UIImage(named: "flashlightOff")
                } else {
                    do {
                        try device?.setTorchModeOnWithLevel(input)
                        flashlight.image = UIImage(named: "flashlightOn")
                    } catch {
                        print(error)
                    }
                }
                
                device?.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
}



