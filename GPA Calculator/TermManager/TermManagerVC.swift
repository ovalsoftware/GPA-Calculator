//
//  TermManagerVC.swift
//  GPA Calculator
//
//  Created by Thameem Hassan on 22-9-24.
//  Copyright © 2024 Arsalan Iravani. All rights reserved.
//

import UIKit
import CoreData

class TermManagerVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var terms = [TermItem]()
    
    var termsSheetDismiss : (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UINib(nibName: TermManagerContentCell.identifier, bundle: nil), forCellReuseIdentifier: TermManagerContentCell.identifier)
        tableView.register(UINib(nibName: TermManagerFooterCell.identifier, bundle: nil), forCellReuseIdentifier: TermManagerFooterCell.identifier)
        fetchTerms()
        
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
    
    
    @objc func showAlertWithTextField() {
        let alertController = UIAlertController(title: "Enter Term Name", message: nil, preferredStyle: .alert)
         
         alertController.addTextField { textField in
             textField.placeholder = "Term Name"
         }
         
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         alertController.addAction(cancelAction)
         
         let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
             if let textField = alertController.textFields?.first, let userInput = textField.text {
                 self?.addTerm(title: userInput)
                 self?.fetchTerms()
                 self?.tableView.reloadData()
             }
         }
         alertController.addAction(submitAction)
         
         self.present(alertController, animated: true, completion: nil)
     }

    func addTerm(title: String){
        let term = TermItem(context: PersistenceController.shared.container.viewContext)
        term.title = title
        PersistenceController.shared.saveContext()

    }

    override func viewDidDisappear(_ animated: Bool) {
        termsSheetDismiss!()
    }
}

extension TermManagerVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == terms.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: TermManagerFooterCell.identifier, for: indexPath) as! TermManagerFooterCell
            cell.addTermBtn.addTarget(self, action: #selector(showAlertWithTextField), for: .touchUpInside)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: TermManagerContentCell.identifier, for: indexPath) as! TermManagerContentCell
            cell.termTitle.text = terms[indexPath.row].title
            return cell
        }
        
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let term = terms[indexPath.row]
            PersistenceController.shared.container.viewContext.delete(term)
            PersistenceController.shared.saveContext()
            fetchTerms()
            tableView.reloadData()
        }
    }

}
