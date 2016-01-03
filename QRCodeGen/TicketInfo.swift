//
//  TicketInfo.swift
//  QRCodeGen
//
//  Created by olgameshchaninova on 03.01.16.
//  Copyright © 2016 MialinVV. All rights reserved.
//

import UIKit
import CoreData

class TicketInfo: UIViewController {
    
    
    @IBOutlet weak var ticketNameLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
               
       ticketNameLabel.text = "ticketID"
        departureLabel.text = "departure"
        destinationLabel.text = "destination"

        
        
        
        /*
        var tickets = [NSManagedObject]()
        let person = tickets[indexPath!.row]
        let dept = tickets[indexPath!.row]
        let dest = tickets[indexPath!.row]
        
        
        ticketNameLabel.text = person.valueForKey("ticketID") as? String
        departureLabel.text = dept.valueForKey("departure") as? String
        destinationLabel.text = dest.valueForKey("destination") as? String
        
        */
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
