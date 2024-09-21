//
//  ContentCell.swift
//  GPA Calculator
//
//  Created by Thameem Hassan on 19-9-24.
//  Copyright © 2024 Arsalan Iravani. All rights reserved.
//

import UIKit

class ContentCell: UITableViewCell {
    static let identifier = "ContentCell"

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var gradeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
