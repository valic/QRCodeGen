
//
//  TicketTableViewCell.swift
//  QRCodeGen
//
//  Created by Мялин Валентин on 1/8/16.
//  Copyright © 2016 MialinVV. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {


    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var dateTimeDepLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
