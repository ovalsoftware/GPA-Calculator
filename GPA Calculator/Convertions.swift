//
//  Convertions.swift
//  GPA Calculator
//
//  Created by Arsalan Iravani on 07.05.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import Foundation
import UIKit

func formatString(_ string: String) -> String {
    return "\(String(format: "%.0f", string))"
}

func formatStringFromFloat(_ float: Float) -> String {
    return "\(String(format: "%.0f", float))"
}

func formatStringFromCGFloat(_ cgfloat: CGFloat) -> String {
    return "\(String(format: "%.0f", cgfloat))"
}

func returnIntFromCGFloat(_ number: CGFloat) -> Int {
    if let n: Int = Int("\(String(format: "%.0f", number))") {
        return n
    }
    return -1
}

func returnIntFromFloat(_ number: Float) -> Int {
    if let n: Int = Int("\(String(format: "%.0f", number))") {
        return n
    }
    return -1
}

func returnIntFromString(_ string: String) -> Int {
    if let n: Int = Int("\(string)") {
        return n
    }
    return -1
}





