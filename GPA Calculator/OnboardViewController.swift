//
//  Page1.swift
//  GPA Calculator
//
//  Created by Arsalan Iravani on 02.10.2017.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController {

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

    @IBAction func getStarted() {

        dismiss(animated: true)
    }

}


//extension Page1: fbdelegate {
//
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//
//        if result?.isCancelled ?? false {
//            print("\n\ncancelled")
//            return
//        }
//
//        if let error = error {
//            print(error.localizedDescription)
//            return
//        }
//
//        print("Login fb")
//
//        guard let fbToken = AccessToken.current?.tokenString else {
//            fatalError("No token from fb 31234")
//        }
//
//        let credential = FacebookAuthProvider.credential(withAccessToken: fbToken)
//
//        Auth.auth().signIn(with: credential) { (authResult, error) in
//            if let error = error {
//                print(error.localizedDescription)
//
//                let alertController = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)
//
//                let permitAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                alertController.addAction(permitAction)
//                self.present(alertController, animated: true, completion: nil)
//                return
//            }
//
//            fetchUserProfile({ (user) in
//                let ref: DocumentReference? = db.collection("users").document((Auth.auth().currentUser?.uid)!)
//
//                ref?.setData([
//                    "name": user?.name as Any,
//                    "lastname": user?.lastname as Any,
//                    "imageURL": user?.imageURL as Any,
//                    "email": Auth.auth().currentUser?.email as Any,
//                    "registered at": Timestamp.init()
//                ], merge: true) { err in
//                    if let err = err {
//                        print("Error adding document: \(err)")
//                    } else {
//                        print("🍓 Document added with ID: \(ref!.documentID)")
//                    }
//                }
//            })
//
//            self.performSegue(withIdentifier: "a", sender: nil)
//        }
//    }
//
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//        do {
//            try Auth.auth().signOut()
//            print("Log out")
//        } catch {}
//    }
//
//}
