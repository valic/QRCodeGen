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
    var ticketIDString:String = ""
    //var counter = 0
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
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        //let row = indexPath.row
      //  cell.textLabel?.text = tickets[indexPath.row]
        let person = tickets[indexPath.row]
        cell.textLabel!.text = person.valueForKey("ticketID") as? String
        
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
        self.tableView.reloadData()
    }
    
   
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        fetch()
        
        let test = tickets[indexPath.row]
        ticketIDString = test.valueForKey("ticketID") as! String
        
        
        self.performSegueWithIdentifier("segueID", sender: nil)
    }
    
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueID" {
            if let destinationVC = segue.destinationViewController as? TicketInfo {
                
                destinationVC.ticketID = ticketIDString
                
                
            }
        }
    }
  
    
    
        
}