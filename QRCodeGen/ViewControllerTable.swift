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
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
      // fetch()

        
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
    var foodNames: [String] = ["Food1","Food2","Food3","Food4","Food5","Food6","Food7","Food8"];
    var foodImages: [String] = ["image1", "image2", "image3","image4","image5","image6","image7","image8"];
    
    
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        //let row = indexPath.row
        cell.textLabel?.text = foodNames[indexPath.row]
        
        //        cell.textLabel!.text = ticketsList[indexPath.item]
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(foodNames[row])
    }
    
    func fetch() {
     //   let context = DataController().managedObjectContext
        let request = NSFetchRequest(entityName: "Tickets")
        
        // Create a sort descriptor object that sorts on the "title"
        // property of the Core Data object
        //let sortDescriptor = NSSortDescriptor(key: "seat", ascending: true)
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
       // request.sortDescriptors = [sortDescriptor]
       // let predicate = NSPredicate(format: "seat == %@", "027 Повний")
       // request.predicate = predicate
        do {
            let results = try DataController().managedObjectContext.executeFetchRequest(request) as! [Tickets]
            
            
            if (results.count > 0) {
                for result in results {
                    print(result.ticketID!)
                }
            } else {
                print("No Data")
            }
            
        
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        

}
        

    }
    

