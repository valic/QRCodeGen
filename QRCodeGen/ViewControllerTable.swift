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
        
        fetch()
        
        ticketTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
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
        let moc = DataController().managedObjectContext
        let personFetch = NSFetchRequest(entityName: "Tickets")
        
        do {
            let fetchedPerson = try moc.executeFetchRequest(personFetch) //as! [Person]
            print(fetchedPerson.first!.string!)
            
            for item in fetchedPerson {
                print(item.string!)
            }
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
}
