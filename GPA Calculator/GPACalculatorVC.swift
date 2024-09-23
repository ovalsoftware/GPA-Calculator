//
//  GPACalculatorVC.swift
//  GPA Calculator
//
//  Created by Thameem Hassan on 19-9-24.
//  Copyright © 2024 Arsalan Iravani. All rights reserved.
//

import UIKit
import CoreData

class GPACalculatorVC: UIViewController {
  
    

    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var termButton: UIButton!
    var items: [Int] = []
    var terms: [TermItem] = []
    var courses: [CourseItem] = []
    var selectedTerm: TermItem?
    
    @IBOutlet weak var termGPALabel: UILabel!
    @IBOutlet weak var termCreditsLabel: UILabel!
    @IBOutlet weak var overallGPALabel: UILabel!
    @IBOutlet weak var overallCreditsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self

        tableview.register(UINib(nibName: HeaderCell.identifier, bundle: nil), forCellReuseIdentifier: HeaderCell.identifier)
        tableview.register(UINib(nibName: ContentCell.identifier, bundle: nil), forCellReuseIdentifier: ContentCell.identifier)
        tableview.register(UINib(nibName: FooterCell.identifier, bundle: nil), forCellReuseIdentifier: FooterCell.identifier)
        tableview.allowsSelection = false
        tableview.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        
        configTerm()
        if let t = terms.first{
            self.termButton.setTitle(t.title ?? "-", for: .normal)
            self.selectedTerm = t
            self.updateCourses()
        }
        updateGPA()
    }
    
    //MARK: - Term
    
    func addTerm(title: String){
        let term = TermItem(context: PersistenceController.shared.container.viewContext)
        term.title = title
        PersistenceController.shared.saveContext()
        print("count: ", terms.count)
        configTerm()
        if let t = terms.first{
            self.termButton.setTitle(t.title ?? "-", for: .normal)
            self.selectedTerm = t
            self.updateCourses()
            self.updateGPA()
        }
    }
    
    func fetchTerms() {
        let managedContext = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TermItem")
        
          do{
              let termItems = try managedContext.fetch(fetchRequest)
              self.terms = termItems as! [TermItem]
              
          } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            
          }
    }
    
    func configTerm(){
        fetchTerms()
        var menuItems = [UIAction]()
        menuItems = terms.map{
            let term = $0
            let action = UIAction(title: term.title ?? "-") { (action) in
                self.termDidChange(term: term)
            }
            return action
        }
        
        let manageTermsBtn = UIAction(title: "Manage Terms", image: UIImage(systemName: "list.bullet.rectangle.portrait")) { (action) in
            let termsManagerVC = TermManagerVC()
            termsManagerVC.modalPresentationStyle = .pageSheet
            termsManagerVC.termsSheetDismiss = {
                self.configTerm()
                if let t = self.terms.first{
                    self.termButton.setTitle(t.title ?? "-", for: .normal)
                    self.selectedTerm = t
                    self.updateCourses()
                    self.updateGPA()
                }
            }
            self.present(termsManagerVC, animated: true)
        }
        
        let addTermBtn = UIAction(title: "Add Term", image: UIImage(systemName: "plus")) { (action) in
            self.showAlertWithTextField()
        }
        
        menuItems.append(manageTermsBtn)
        menuItems.append(addTermBtn)
        
        let menu = UIMenu(options: .displayInline, children: menuItems)
        termButton.showsMenuAsPrimaryAction = true
        termButton.menu = menu
        
    }
    
    
    func showAlertWithTextField() {
        let alertController = UIAlertController(title: "Enter Term Name", message: nil, preferredStyle: .alert)
         
         alertController.addTextField { textField in
             textField.placeholder = "Term Name"
         }
         
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         alertController.addAction(cancelAction)
         
         let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
             if let textField = alertController.textFields?.first, let userInput = textField.text {
                 self?.addTerm(title: userInput)
             }
         }
         alertController.addAction(submitAction)
         
         self.present(alertController, animated: true, completion: nil)
     }
    
    func termDidChange(term: TermItem){
        guard selectedTerm != nil else{
            if let t = terms.first{
                self.termButton.setTitle(t.title ?? "-", for: .normal)
                self.selectedTerm = t
            }
            return
        }
        self.termButton.setTitle(term.title ?? "-", for: .normal)
        self.selectedTerm = term
        self.updateCourses()
        self.updateGPA()
    }
    
    //MARK: - Course
    
    func updateCourses(){
        guard let term = self.selectedTerm else {return}
        courses = term.courses?.allObjects as [CourseItem]
        tableview.reloadData()
    }
    
    @objc func showAlertWithTextFieldForCourse(){
        let alertController = UIAlertController(title: "Enter Course Name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Course Name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Credits"
            textField.keyboardType = .numberPad
        }
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { _ in
            if let titleField = alertController.textFields?.first, let creditsField = alertController.textFields?[1] {
                self.addCourse(title: titleField.text ?? "-", credits: Int(creditsField.text ?? "0") ?? 0)
            }
            
        })
        alertController.addAction(addAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addCourse(title: String, credits: Int){
        guard let term = selectedTerm else {return}
        guard title.isEmpty == false else {return}
        guard credits != 0 else {return}
        let course = CourseItem(context: PersistenceController.shared.container.viewContext)
        course.credits = Int16(credits)
        course.title = title
        term.addToCourses(course)
        PersistenceController.shared.saveContext()
        updateCourses()
        updateGPA()
    }
    
    func saveGrade(course: CourseItem, grade: String){
        course.grade = grade
        PersistenceController.shared.saveContext()
        tableview.reloadData()
        updateGPA()
    }
    
    
    //MARK: - GPA

    func updateGPA(){
        let termGPA = getTermGPA()
        let termGPAVal = String(format: "%.2f", termGPA)
        termGPALabel.text = "\(termGPAVal)"
        let gpa = getOverallGPA()
        let overallGPAVal = String(format: "%.2f", gpa)
        overallGPALabel.text = "\(overallGPAVal)"
    }
    
    private func getTermGPA() -> Double {
        var point = 0.0
        var sumOfCretids = 0.0
        guard let term = selectedTerm else {return 0.0}
        for course in term.courses?.allObjects as [CourseItem] {
            var gradePoints: Double = 0.0
            if let grade = course.grade {
                gradePoints = grades[grade] ?? 0.0
            }
            point += Double(course.credits) * Double(gradePoints)
            sumOfCretids += Double(course.credits)
        }
        
        self.termCreditsLabel.text = "\(Int(sumOfCretids)) Credits"
        if !(point / sumOfCretids).isNaN {
            return point / sumOfCretids
        }
        return 0.0
    }
    
    private func getOverallGPA() -> Double {
        var point = 0.0
        var sumOfCretids = 0.0
        
        for term in terms {
            for course in term.courses?.allObjects as [CourseItem] {
                var gradePoints: Double = 0.0
                if let grade = course.grade {
                    gradePoints = grades[grade] ?? 0.0
                }
                point += Double(course.credits) * Double(gradePoints)
                sumOfCretids += Double(course.credits)
            }
        }
        
        self.overallCreditsLabel.text = "\(Int(sumOfCretids)) Credits"
        if !(point / sumOfCretids).isNaN {
            return point / sumOfCretids
        }

        return 0.0
    }
}

extension GPACalculatorVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
             let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.identifier, for: indexPath) as! HeaderCell
             return cell
        } else if indexPath.row == courses.count + 1 {
             let cell = tableView.dequeueReusableCell(withIdentifier: FooterCell.identifier, for: indexPath) as! FooterCell
            cell.addCourceBtn.addTarget(self, action: #selector(showAlertWithTextFieldForCourse), for: .touchUpInside)
             return cell
         } else {
             let cell = tableView.dequeueReusableCell(withIdentifier: ContentCell.identifier, for: indexPath) as! ContentCell
             let course = courses[indexPath.row - 1]
             cell.title.text = course.title
             cell.creditsLabel.text = "\(course.credits)"
             
             var menuItems = [UIAction]()
             let gradeArray = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "F"]

             menuItems = gradeArray.map{
                 let grade = $0
                 let action = UIAction(title: grade) { (action) in
                     self.saveGrade(course: course, grade: grade)
                 }
                 return action
             }
             
             let emptyItem = UIAction(title: "-") { (action) in
                 self.saveGrade(course: course, grade: "-")
             }
             
             menuItems.append(emptyItem)
             let menu = UIMenu(options: .displayInline, children: menuItems)
             cell.gradeBtn.menu = menu
             cell.gradeBtn.showsMenuAsPrimaryAction = true
             cell.gradeBtn.setTitle(course.grade ?? "-", for: .normal)
             return cell
         }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let courses = selectedTerm?.courses?.allObjects as [CourseItem]
            let course = courses[indexPath.row - 1]
            PersistenceController.shared.container.viewContext.delete(course)
            PersistenceController.shared.saveContext()
            if let term = selectedTerm {
                termDidChange(term: term)
            }
        }
    }

}
