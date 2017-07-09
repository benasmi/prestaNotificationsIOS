//
//  OrderCell.swift
//  PrestaNotificationsF
//
//  Created by Ignas Paulionis on 06/01/2017.
//  Copyright © 2017 Ignas Paulionis. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

  
 
    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var orderReference: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var orderReferenceLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    var isExpanded:Bool = false
        {
        didSet
        {
            if !isExpanded {
                self.cellHeight.constant = 47.0

            } else {
                self.cellHeight.constant = 90.0
                
                
            }
            
            print(self.cellHeight.constant)
        }
    }

}
