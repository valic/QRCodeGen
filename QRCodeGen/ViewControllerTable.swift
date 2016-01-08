//
//  ViewControllerTable.swift
//  QRCodeGen
//
//  Created by olgameshchaninova on 17.12.15.
//  Copyright © 2015 MialinVV. All rights reserved.
//

import UIKit
import CoreData


class ViewControllerTable: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var tickets = [NSManagedObject]()
    let textCellIdentifier = "TextCell" // func tableView
    
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
    
    let moc = DataController().managedObjectContext
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    //   fetch()
        
       // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        fetch()
        //  fetchingFromCoreData ()
        
    }

    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! TicketTableViewCell
        //let row = indexPath.row
      //  cell.textLabel?.text = tickets[indexPath.row]
        let person = tickets[indexPath.row]
        cell.departureLabel!.text = stringRemoveRange10((person.valueForKey("departure") as? String)!)
        cell.destinationLabel!.text = stringRemoveRange10((person.valueForKey("destination") as? String)!)
        let dateTimeDep = person.valueForKey("dateTimeDep") as! NSDate
        let dateTimeDes = person.valueForKey("dateTimeDes") as! NSDate
        
        cell.dateTimeDepLabel!.text = dateToString(dateTimeDep)
        
        cell.backgroundColor = UIColor.redColor()
        
        print(isBetweenMyTwoDates(dateTimeDep, end: dateTimeDes))
        
      //  cell.imageView?.image = UIImage(named: "park2.png")
       
      //  image2
        
        //        cell.textLabel!.text = ticketsList[indexPath.item]
        
        return cell
    }

    
    func fetch() {
        
        do {
            let request = NSFetchRequest(entityName: "Tickets")
            tickets = try moc.executeFetchRequest(request) as! [Tickets]
        
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
       self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
          
        moc.deleteObject(tickets[indexPath.row])
            
        do {
            try moc.save()
        } catch {
                print("failed to clear core data")
                }
        }
        self.tickets.removeAtIndex(indexPath.row)
      //  self.tableView.reloadData()
    }
    
   
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        fetch()
        
        let test = tickets[indexPath.row]
                
        stringTicket = test.valueForKey("stringTicket") as! String
        train = test.valueForKey("train") as! String
        departure = test.valueForKey("departure") as! String
        destination = test.valueForKey("destination") as! String
        coach = test.valueForKey("coach") as! String
        seat = test.valueForKey("seat") as! String
        surnameAndName = test.valueForKey("surnameAndName") as! String
        cost = test.valueForKey("cost") as! Float
        dateTimeDep = test.valueForKey("dateTimeDep") as! NSDate
        dateTimeDes = test.valueForKey("dateTimeDes") as! NSDate
        ticketID = test.valueForKey("ticketID") as! String
        
        self.performSegueWithIdentifier("segueID", sender: nil)
    }
    
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueID" {
            if let destinationVC = segue.destinationViewController as? TicketInfo {
                
                destinationVC.stringTicket = stringTicket
                destinationVC.train = train
                destinationVC.departure = departure
                destinationVC.destination = destination
                destinationVC.coach = coach
                destinationVC.seat = seat
                destinationVC.surnameAndName = surnameAndName
                destinationVC.cost = cost
                destinationVC.dateTimeDep = dateTimeDep
                destinationVC.dateTimeDes = dateTimeDes
                destinationVC.ticketID = ticketID
            }
        }
    }
    
    func stringRemoveRange10 (string: String) -> String {
        let range  = string.startIndex.advancedBy(10)..<string.endIndex
        return string[range]
    }
    
    func dateToString (date: NSDate) -> String  {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM HH:mm"
        return dateFormatter.stringFromDate(date)
    }
    
    
//    let dateMaker = NSDateFormatter()
//    dateMaker.dateFormat = "yyyy/MM/dd HH:mm:ss"
//    let start = dateMaker.dateFromString("2016/01/01 08:00:00")!
//    let end = dateMaker.dateFromString("2016/02/15 16:30:00")!
    
    func isBetweenMyTwoDates(start: NSDate, end: NSDate ) -> Bool {
        if start.compare(NSDate()) == .OrderedAscending && end.compare(NSDate()) == .OrderedDescending {
            return true
        }
        return false
    }

  
    
    
        
}