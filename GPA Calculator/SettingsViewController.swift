//
//  SettingsViewController.swift
//  FirebaseCore
//
//  Created by Arsalan Iravani on 08/01/2020.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var AplusTextField: UITextField!
    @IBOutlet weak var ATextField: UITextField!
    @IBOutlet weak var AminusTextField: UITextField!
    
    @IBOutlet weak var BplusTextField: UITextField!
    @IBOutlet weak var BTextField: UITextField!
    @IBOutlet weak var BminusTextField: UITextField!
    
    @IBOutlet weak var CplusTextField: UITextField!
    @IBOutlet weak var CTextField: UITextField!
    @IBOutlet weak var CminusTextField: UITextField!
    
    @IBOutlet weak var DplusTextField: UITextField!
    @IBOutlet weak var DTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fillTextFieldsGrades()
    }
    
    func fillTextFieldsGrades() {
        AplusTextField.text = "\(grades["A+"]!)"
        ATextField.text = "\(grades["A"]!)"
        AminusTextField.text = "\(grades["A-"]!)"
        
        BplusTextField.text = "\(grades["B+"]!)"
        BTextField.text = "\(grades["B"]!)"
        BminusTextField.text = "\(grades["B-"]!)"
        
        CplusTextField.text = "\(grades["C+"]!)"
        CTextField.text = "\(grades["C"]!)"
        CminusTextField.text = "\(grades["C-"]!)"
        
        DplusTextField.text = "\(grades["D+"]!)"
        DTextField.text = "\(grades["D"]!)"
    }
    
    
    
}

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        textField.text = textField.text?.replacingOccurrences(of: ",", with: ".")
        
//        let range = (textField.text?.index(after: (textField.text?.firstIndex(of: ".")!)!))! ..< (textField.text ?? "").endIndex
//        textField.text = textField.text?.replacingOccurrences(of: ".", with: "", range: range)
        
        grades["A+"] = Double(AplusTextField.text ?? "\(grades["A+"]!)")
        grades["A"] = Double(ATextField.text ?? "\(grades["A"]!)")
        grades["A-"] = Double(AminusTextField.text ?? "\(grades["A-"]!)")
        
        grades["B+"] = Double(BplusTextField.text ?? "\(grades["B+"]!)")
        grades["B"] = Double(BTextField.text ?? "\(grades["B"]!)")
        grades["B-"] = Double(BminusTextField.text ?? "\(grades["B-"]!)")
        
        grades["C+"] = Double(CplusTextField.text ?? "\(grades["C+"]!)")
        grades["C"] = Double(CTextField.text ?? "\(grades["C"]!)")
        grades["C-"] = Double(CminusTextField.text ?? "\(grades["C-"]!)")
        
        grades["D+"] = Double(DplusTextField.text ?? "\(grades["D+"]!)")
        grades["D"] = Double(DTextField.text ?? "\(grades["D"]!)")
 
        saveGrades()
    }
}
