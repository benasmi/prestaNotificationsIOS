//
//  MessageCell.swift
//  PrestaNotificationsF
//
//  Created by Benas on 10/01/2017.
//  Copyright © 2017 Ignas Paulionis. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var buyerName: UILabel!
    @IBOutlet weak var date: UILabel!
    var expandedHeight:Int = 0;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    
    var isExpanded:Bool = false
        {
        didSet
        {
            
            if !isExpanded {
                self.cellHeight.constant = 47.0
            } else {
                self.cellHeight.constant = CGFloat(Double(expandedHeight+47))
            }
            
            print(self.cellHeight.constant)
        }
    }


}
