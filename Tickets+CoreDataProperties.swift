//
//  Tickets+CoreDataProperties.swift
//  QRCodeGen
//
//  Created by Мялин Валентин on 12/27/15.
//  Copyright © 2015 MialinVV. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tickets {

    @NSManaged var train: String?
    @NSManaged var departure: String?
    @NSManaged var destination: String?
    @NSManaged var dateTimeDep: Date?
    @NSManaged var dateTimeDes: Date?
    @NSManaged var coach: String?
    @NSManaged var seat: String?
    @NSManaged var surnameAndName: String?
    @NSManaged var cost: NSNumber?
    @NSManaged var ticketID: String?
    @NSManaged var stringTicket: String?

}
