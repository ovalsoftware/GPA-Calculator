//
//  GradientView.swift
//  GPA Calculator
//
//  Created by Arsalan Iravani on 07.05.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import UIKit

//@IBDesignable
class GradientView: UIView {
    
    @IBInspectable
    var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as? CAGradientLayer
        layer?.colors = [firstColor.cgColor, secondColor.cgColor]
    }
}
