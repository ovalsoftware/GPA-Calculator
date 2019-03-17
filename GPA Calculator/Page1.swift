//
//  Page1.swift
//  GPA Calculator
//
//  Created by Arsalan Iravani on 02.10.2017.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import UIKit

class Page1: UIViewController {
    
    
    @IBOutlet weak var finger: UIImageView!
    @IBOutlet weak var finger2: UIImageView!
    @IBOutlet weak var finger3: UIImageView!
    @IBOutlet var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStartedButton.layer.cornerRadius = 8
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Swipe Animation
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
            self.finger.frame.origin.x = self.finger.frame.origin.x - 50
        })

        // Hold Animation
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut, .repeat, .autoreverse], animations: {
            self.finger2.frame.size = CGSize(width: 40, height: 40)
        })

        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut, .repeat, .autoreverse], animations: {
            self.finger3.frame.size = CGSize(width: 40, height: 40)
        })
    }
}
