
//
//  TicketTableViewCell.swift
//  QRCodeGen
//
//  Created by Мялин Валентин on 1/8/16.
//  Copyright © 2016 MialinVV. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {




    @IBOutlet weak var dateTimeDepLabelTop: UILabel!
    @IBOutlet weak var train: UILabel!
    @IBOutlet weak var railroadCar: UILabel!
    @IBOutlet weak var timeDepLabel: UILabel!
    @IBOutlet weak var dateDepLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var timeDesLabel: UILabel!
    @IBOutlet weak var dateDesLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!


   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
