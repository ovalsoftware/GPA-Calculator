//
//  Functions.swift
//  GPA Calculator
//
//  Created by Arsalan Iravani on 07.05.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import Foundation

func isValidGrade(stringToCheck : String) -> Bool {
    for grade in grades.keys {
        if stringToCheck == grade {
            return true
        }
    }
    return false
}

func saveGrades(){
    UserDefaults.standard.set(grades, forKey: "grades")
}

func getGrades() -> Dictionary<String, Double>? {
    return UserDefaults.standard.value(forKey: "grades") as? Dictionary<String, Double>
}
