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
    let textCellIdentifier = "TextCell"

    
    
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
            tickets = try DataController().managedObjectContext.executeFetchRequest(request) as! [Tickets]
        
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
    func refresh(){
        do {
            let request = NSFetchRequest(entityName: "Tickets")
            tickets = try DataController().managedObjectContext.executeFetchRequest(request) as! [Tickets]
            
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }

    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 1
        if editingStyle == .Delete {
            
            
            self.tickets.removeAtIndex(indexPath.row)
            
            self.tableView.reloadData()
            
                    }
    }
        
}
    

