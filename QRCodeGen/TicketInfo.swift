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
    var dateTimeDep = Date()
    var dateTimeDes = Date()
    var ticketID = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let edgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: Selector(("userSwipedFromEdge:")))
        edgeGestureRecognizer.edges = UIRectEdge.left
        edgeGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(edgeGestureRecognizer)
        
        departureLabel.text = stringRemoveRange10(departure)
        destinationLabel.text = stringRemoveRange10(destination)
        
        trainLabel.text = (String((train as NSString).integerValue))
        coachLabel.text = coach
        seatLabel.text = (String((seat as NSString).integerValue))
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        costLabel.text = nf.string(from: NSNumber(value: cost))! + " \u{20B4}"
        
        dateTimeDepLabel.text = dateToString(dateTimeDep)
        dateTimeDesLabel.text = dateToString(dateTimeDes)
        ticketIdLabel.text = ticketID
        generationQR(stringTicket)
        
        // Do any additional setup after loading the view.
        
    //    self.imgQRCode.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        self.navigationItem.title = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // анимация
       UIView.animate(withDuration: 0.9, delay: 0, options: [], animations: {self.imgQRCode.transform = CGAffineTransform.identity}, completion: nil)
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func generationQR (_ textQR: String) {
        
        let data = textQR.data(using: String.Encoding.utf8, allowLossyConversion: false)
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
        
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        imgQRCode.image = UIImage(ciImage: transformedImage)
        
    }
    
    func stringRemoveRange10 (_ string: String) -> String {
        let range  = string.characters.index(string.startIndex, offsetBy: 10)..<string.endIndex
        return string[range]
    }
    
    func dateToString (_ date: Date) -> String  {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        return dateFormatter.string(from: date)
    }

    @IBAction func tapImageQR(_ sender: AnyObject) {
        
       // self.imgQRCode.transform = CGAffineTransformMakeScale(1.0, 1.0)
        let screenSize: CGRect = UIScreen.main.bounds
        
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
