//
//  GradeCell.swift
//  GPA Calculator
//
//  Created by Arsalan Iravani on 1/25/19.
//  Copyright © 2019 Arsalan Iravani. All rights reserved.
//

import UIKit

class GradeCell: UICollectionViewCell {
    
    @IBOutlet weak var gradeLabel: UILabel!

    override func awakeFromNib() {
        gradeLabel.adjustsFontSizeToFitWidth = true
    }

}
