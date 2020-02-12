//
//  Grades.swift
//  GPA Calculator
//
//  Created by Arsalan Iravani on 21.04.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import Foundation

/// Predefined relationship of Grades
var grades: [String: Double] = ["A+": 4, "A": 4, "A-": 3.67, "B+": 3.33, "B": 3, "B-": 2.67 ,"C+": 2.33,"C": 2,"C-": 1.67,"D+": 1.33,"D": 1,"F": 0]

/// Class with 2 attributes :
/// 1. Grade : Stores Double values like 3.67
/// 2. Credit : Stores Int values like 6

class Grade: NSObject {
    var grade: Double
    var credit: Int
    
    init(grade: Double, credit: Int) {
        self.grade = grade
        self.credit = credit
    }

    static func returnStringFromDouble(gradeDouble: Double) -> String? {
        for grade in grades {
            if gradeDouble == grade.value {
                return grade.key
            }
        }
        return nil
    }
    
}

