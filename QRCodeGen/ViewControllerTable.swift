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
    var dateTimeDep = Date()
    var dateTimeDes = Date()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        fetch()
        //  fetchingFromCoreData ()
        
    }

    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! TicketTableViewCell

        let person = tickets[(indexPath as NSIndexPath).row]
        
        cell.dateTimeDepLabelTop?.text = person.value(forKey: "dateTimeDep") as? String
        cell.train?.text =  String(describing: (person.value(forKey: "train") as! NSString).integerValue)      
        cell.railroadCar?.text = person.value(forKey: "coach") as? String
        
        let dateTimeDep  = person.value(forKey: "dateTimeDep") as? Date
        let dateTimeDes  = person.value(forKey: "dateTimeDes") as? Date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        
        cell.timeDepLabel?.text = dateFormatter.string(from: dateTimeDep!)
        cell.timeDesLabel?.text = dateFormatter.string(from: dateTimeDes!)
        
        dateFormatter.dateFormat = "dd.MM"
        cell.dateDepLabel?.text = dateFormatter.string(from: dateTimeDep!)
        cell.dateDesLabel?.text = dateFormatter.string(from: dateTimeDes!)
        
        
        cell.departureLabel!.text = stringRemoveRange10((person.value(forKey: "departure") as? String)!)
        cell.destinationLabel!.text = stringRemoveRange10((person.value(forKey: "destination") as? String)!)
 
        
        
        //print(dateTimeDes)
       // cell.dateTimeDepLabel!.text = dateToString(dateTimeDep)
       // cell.userInteractionEnabled = true
        
        
        if (dateEnd(dateTimeDes!) == true) {
        cell.contentView.alpha = 0.75
            }
        else {
            print("Дата в билете актуальна")
        }
        
        return cell
    }

    
    func fetch() {
        
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tickets")
            tickets = try moc.fetch(request) as! [Tickets]
        
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
       self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          
        moc.delete(tickets[(indexPath as NSIndexPath).row])
            
        do {
            try moc.save()
        } catch {
                print("failed to clear core data")
                }
        }
        self.tickets.remove(at: (indexPath as NSIndexPath).row)
        self.tableView.reloadData()
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fetch()
        
        let test = tickets[(indexPath as NSIndexPath).row]
                
        stringTicket = test.value(forKey: "stringTicket") as! String
        train = test.value(forKey: "train") as! String
        departure = test.value(forKey: "departure") as! String
        destination = test.value(forKey: "destination") as! String
        coach = test.value(forKey: "coach") as! String
        seat = test.value(forKey: "seat") as! String
        surnameAndName = test.value(forKey: "surnameAndName") as! String
        cost = test.value(forKey: "cost") as! Float
        dateTimeDep = test.value(forKey: "dateTimeDep") as! Date
        dateTimeDes = test.value(forKey: "dateTimeDes") as! Date
        ticketID = test.value(forKey: "ticketID") as! String
        
        self.performSegue(withIdentifier: "segueID", sender: nil)
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueID" {
            if let destinationVC = segue.destination as? TicketInfo {
                
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
    
    func stringRemoveRange10 (_ string: String) -> String {
        let range  = string.characters.index(string.startIndex, offsetBy: 10)..<string.endIndex
        return string[range]
    }
    
    func dateToString (_ date: Date) -> String  {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM HH:mm"
        return dateFormatter.string(from: date)
    }

    
    func isBetweenMyTwoDates(_ start: Date, end: Date ) -> Bool {
        if start.compare(Date()) == .orderedAscending && end.compare(Date()) == .orderedDescending {
            return true
        }
        return false
    }
    
    func dateEnd(_ end: Date ) -> Bool {
    //    var dateComparisionResult:NSComparisonResult = currentDate.compare(end)
        if Date().compare(end) == ComparisonResult.orderedDescending {
            
            return true
        }
        return false
    }

  
    
    
        
}
