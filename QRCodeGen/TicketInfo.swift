//
//  TicketInfo.swift
//  QRCodeGen
//
//  Created by olgameshchaninova on 03.01.16.
//  Copyright © 2016 MialinVV. All rights reserved.
//

import UIKit
import CoreData

class TicketInfo: UIViewController,UIGestureRecognizerDelegate {
    
    
    
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var trainLabel: UILabel!
    @IBOutlet weak var coachLabel: UILabel!
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var dateTimeDepLabel: UILabel!
    @IBOutlet weak var dateTimeDesLabel: UILabel!
    @IBOutlet weak var ticketIdLabel: UILabel!
    
    
    
    var qrcodeImage: CIImage!
    

    //Int(myString)

    var stringTicket = ""
    var train = ""
    var departure = ""
    var destination = ""
    var coach = ""
    var seat = ""
    var surnameAndName = ""
    var cost:Float = 0.0
    var dateTimeDep = NSDate()
    var dateTimeDes = NSDate()
    var ticketID = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let edgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "userSwipedFromEdge:")
        edgeGestureRecognizer.edges = UIRectEdge.Left
        edgeGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(edgeGestureRecognizer)
        
        departureLabel.text = stringRemoveRange10(departure)
        destinationLabel.text = stringRemoveRange10(destination)
        
        trainLabel.text = (String((train as NSString).integerValue))
        coachLabel.text = coach
        seatLabel.text = (String((seat as NSString).integerValue))
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        costLabel.text = nf.stringFromNumber(cost)! + " \u{20B4}"
        
        dateTimeDepLabel.text = dateToString(dateTimeDep)
        dateTimeDesLabel.text = dateToString(dateTimeDes)
        ticketIdLabel.text = ticketID
        generationQR(stringTicket)
        
        // Do any additional setup after loading the view.
        
    //    self.imgQRCode.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        self.navigationItem.title = ""
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // анимация
       UIView.animateWithDuration(0.9, delay: 0, options: [], animations: {self.imgQRCode.transform = CGAffineTransformIdentity}, completion: nil)
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func generationQR (textQR: String) {
        
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
    
    func stringRemoveRange10 (string: String) -> String {
        let range  = string.startIndex.advancedBy(10)..<string.endIndex
        return string[range]
    }
    
    func dateToString (date: NSDate) -> String  {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        return dateFormatter.stringFromDate(date)
    }

    @IBAction func tapImageQR(sender: AnyObject) {
        
       // self.imgQRCode.transform = CGAffineTransformMakeScale(1.0, 1.0)
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        imgQRCode.frame = CGRect(x: screenSize.width/2-(screenSize.width*0.9/2), y: screenSize.height/2-(screenSize.width*0.9/2), width: screenSize.width*0.9, height: screenSize.width*0.9)
        
    }


    
//    func userSwipedFromEdge(sender: UIScreenEdgePanGestureRecognizer) {
//        if sender.edges == UIRectEdge.Left {
//            print("It works!")
//            self.performSegueWithIdentifier("done", sender: nil)
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
