//
//  ViewController.swift
//  GPA Calculator
//
//  Created by Arsalan Iravani on 21.01.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import UIKit
import StoreKit
import KTCenterFlowLayout

class ViewController: UIViewController {
    
    var isLoginSuccess = false

    @IBOutlet weak var gpaLabel: UILabel!
    @IBOutlet weak var enterGradeLabel: UILabel!
    
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
    @IBOutlet weak var d1: UIButton!
    @IBOutlet weak var d2: UIButton!
    @IBOutlet weak var f1: UIButton!
    
    var color1: UIColor = UIColor(red: 1 , green: 0.58, blue: 0, alpha: 1)
    var color2: UIColor = UIColor(red: 0.58, green: 0.07, blue: 0.07, alpha: 1)
    
    /// Array that stores Grade object [grade: Double, credit Int]
    var myGrades: [Grade] = []
    let gradient = CAGradientLayer()
    var creditSelected = false
    var grade = ""

    var numberOfTaps = 0
    
    let generator = UIImpactFeedbackGenerator(style: .light)

    //MARK: - ADD haptic, ADD sound

    @IBOutlet weak var collectionView: UICollectionView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gpaLabel.adjustsFontSizeToFitWidth = true

        addGesture()
        createGradient()
        
        generator.prepare()

        let layout = KTCenterFlowLayout()
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 5.0
        layout.itemSize = CGSize(width: 80, height: 30)
        layout.sectionInset.top = 10
        collectionView.setCollectionViewLayout(layout, animated: true)

        enterGradeLabel.adjustsFontSizeToFitWidth = true

        showGrades()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if UserDefaults.standard.value(forKey: stringKey) == nil {
            // show onboarding screen
            let vc = storyboard?.instantiateViewController(withIdentifier: "OnboardingID") as! OnboardViewController
            UserDefaults.standard.setValue("true", forKey: stringKey)

            present(vc, animated: true)
        }
    }


    /// Change font color of buttons
    ///
    /// - Parameter color: UIColor
    func setButtomsColor(_ color: UIColor) {
        a1.setTitleColor(color, for: .normal)
        a2.setTitleColor(color, for: .normal)
        a3.setTitleColor(color, for: .normal)
        
        b1.setTitleColor(color, for: .normal)
        b2.setTitleColor(color, for: .normal)
        b3.setTitleColor(color, for: .normal)
        
        c1.setTitleColor(color, for: .normal)
        c2.setTitleColor(color, for: .normal)
        c3.setTitleColor(color, for: .normal)
        
        d1.setTitleColor(color, for: .normal)
        d2.setTitleColor(color, for: .normal)
        f1.setTitleColor(color, for: .normal)
    }

    /// User selected grade or creadit
    ///
    /// - Parameter sender: UIButton
    @IBAction func buttonPressed(_ sender: UIButton) {
        numberOfTaps += 1

        if numberOfTaps == 15 {
            SKStoreReviewController.requestReview()
        }

        if !creditSelected {
            grade = (sender.titleLabel?.text!)! as String
            if isValidGrade(stringToCheck: grade) { // prevent bug from quick double tap
                showCredits()
                creditSelected = true
            }
        } else if let credit = sender.titleLabel?.text {
            guard let g = grades[grade], let c = Int(credit) else { return }
            myGrades.append(Grade(grade: g, credit: c))
            gpaLabel.text = "GPA: \(String(format: "%.2f", findAverage()))"
            showGrades()
            creditSelected = false
        }

        collectionView.reloadData()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right, .left:
                if !myGrades.isEmpty {
                    myGrades.removeLast()
                    collectionView.reloadData()
                    gpaLabel.text = "GPA: \(String(format: "%.2f", findAverage()))"
                }
                showGrades()
                creditSelected = false
            default:
                break
            }
        }
    }
    
    /// Long tap gesture action
    ///
    /// - Parameter sender: UIGestureRegognizer
    @objc func longTap(_ sender : UIGestureRecognizer){
        if sender.state == .began {
            myGrades.removeAll()
            collectionView.reloadData()
            gpaLabel.text = "GPA: \(String(format: "%.2f", findAverage()))"
            showGrades()
            creditSelected = false
        }
    }

    
    /// Calculate average grade
    ///
    /// - Returns: GPA
    func findAverage() -> Double {
        var point = 0.0
        var sumOfCretids = 0.0
        
        for grade in myGrades {
            point += grade.grade * Double(grade.credit)
            sumOfCretids += Double(grade.credit)
        }
        
        if !(point / sumOfCretids).isNaN {
            return point / sumOfCretids
        }
        
        return 0
    }
    
    /// Create background gradient
    func createGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color2.cgColor, color1.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = self.view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    /// Add gestures to the screen
    func addGesture() {
        // Swipe
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            gesture.direction = direction
            view.addGestureRecognizer(gesture)
            collectionView.addGestureRecognizer(gesture)
        }
        
        // Hold
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap))
        view.addGestureRecognizer(longGesture)
        collectionView.addGestureRecognizer(longGesture)
    }
    
    /// Make buttons change their title to grades (A+, A, ...)
    func showGrades() {
        a1.setTitle("A+", for: .normal)
        a2.setTitle("A", for: .normal)
        a3.setTitle("A-", for: .normal)
        b1.setTitle("B+", for: .normal)
        b2.setTitle("B", for: .normal)
        b3.setTitle("B-", for: .normal)
        c1.setTitle("C+", for: .normal)
        c2.setTitle("C", for: .normal)
        c3.setTitle("C-", for: .normal)
        d1.setTitle("D+", for: .normal)
        d2.setTitle("D", for: .normal)
        f1.setTitle("F", for: .normal)

        enterGradeLabel.text = "Tap a Grade"
    }
    
    /// Make buttons change their title to creadits (1, 2, ...)
    func showCredits() {
        a1.setTitle("1", for: .normal)
        a2.setTitle("2", for: .normal)
        a3.setTitle("3", for: .normal)
        b1.setTitle("4", for: .normal)
        b2.setTitle("5", for: .normal)
        b3.setTitle("6", for: .normal)
        c1.setTitle("7", for: .normal)
        c2.setTitle("8", for: .normal)
        c3.setTitle("9", for: .normal)
        d1.setTitle("10", for: .normal)
        d2.setTitle("11", for: .normal)
        f1.setTitle("12", for: .normal)

        enterGradeLabel.text = "Tap a Credit"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showGrades()
        creditSelected = false
    }
    
    
//    @IBAction func settingPressed() {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsID") as! SettingsViewController
//        UserDefaults.standard.setValue("true", forKey: stringKey)
//
//        present(vc, animated: true)
//    }
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myGrades.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GradeCell
        cell.gradeLabel.text = Grade.returnStringFromDouble(gradeDouble: myGrades[indexPath.row].grade)! + "  \(myGrades[indexPath.row].credit)"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        myGrades.remove(at: indexPath.row)
        collectionView.reloadData()
        gpaLabel.text = "GPA: \(String(format: "%.2f", findAverage()))"
        
        generator.impactOccurred()
    }
}
