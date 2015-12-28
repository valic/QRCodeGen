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

    @IBOutlet weak var ticketTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      // fetch()
        
        ticketTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
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
    
    var foodNames: [String] = ["Food1","Food2","Food3","Food4","Food5","Food6","Food7","Food8"];
    var foodImages: [String] = ["image1", "image2", "image3","image4","image5","image6","image7","image8"];
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print(foodNames.count)
        return foodNames.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "mycell")
        cell.textLabel!.text = foodNames[indexPath.row]
        tableView.reloadData()
        
        //let image : UIImage = UIImage(named: foodImages[indexPath.row])!
        //cell.imageView!.image = image
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    

