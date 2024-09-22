//
//  TermManagerContentCell.swift
//  GPA Calculator
//
//  Created by Thameem Hassan on 22-9-24.
//  Copyright © 2024 Arsalan Iravani. All rights reserved.
//

import UIKit

class TermManagerContentCell: UITableViewCell {
    static let identifier = "TermManagerContentCell"
   
    @IBOutlet weak var termTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
