//
//  LoginVC.swift
//  Twitterrr
//
//  Created by macbook air on 09/05/1443 AH.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginUserVC: UIViewController {
  
  //MARK: - Properties
  
  let db = Firestore.firestore()

  // MAKR: - IBOutlet
  
  @IBOutlet weak var emailTF: UITextField!
  @IBOutlet weak var passwordTF: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  
  
  //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
      self.dismissKeyboard()
      navigationItem.backButtonTitle = "Back"
    }
    
  //MARK: - IBActions

  @IBAction func Login(_ sender: UIButton) {
    loginUserPressed()
  }
  
  
  @objc private func loginUserPressed() {
        guard let email = emailTF.text else {return}
        guard let password = passwordTF.text else {return}
        print("clicked")
        if !email.isEmpty && !password.isEmpty {
            loginUsing(email: email,
                       password: password)
          
        } else {
            let alert = UIAlertController(title: "Oops!",
                                          message: "please make sure email and password are not empty.",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .cancel,
                                          handler: nil))
            
            present(alert,
                    animated: true)
        }
    }
    
  //MARK: - Methode

    private func loginUsing(email: String,
                            password: String) {
        print("clicked")
        Auth.auth().signIn(withEmail: email,
                           password: password) { results, error in
            
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .wrongPassword:
                    
                    let alert = UIAlertController(title: "Oops!",
                                                  message: "you entered a wrong password",
                                                  preferredStyle: .alert)
                  
                    alert.addAction(UIAlertAction(title: "OK",
                                                  style: .cancel,
                                                  handler: nil))
                  
                    self.present(alert,
                                 animated: true)
                case .invalidEmail:
                    
                    let alert = UIAlertController(title: "Oops!",
                                                  message: "are sure you typed the email correctly?",
                                                  preferredStyle: .alert)
                  
                    alert.addAction(UIAlertAction(title: "OK",
                                                  style: .cancel,
                                                  handler: nil))
                  
                    self.present(alert,
                                 animated: true)
            
                default:
                    let alert = UIAlertController(title: "Oops!",
                                                  message: "\(error.localizedDescription)",
                                                  preferredStyle: .alert)
                  
                    alert.addAction(UIAlertAction(title: "OK",
                                                  style: .cancel,
                                                  handler: nil))
                  
                    self.present(alert,
                                 animated: true)
                }
            } else {
                guard let user = results?.user else {return}
                
                self.db.collection("UserProfile").document(user.uid).setData([
                    "email": String(user.email!),
                    "userID": user.uid,
                ], merge: true) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
              self.transitionToHome()
            }
        }
    }
  
  //MARK: - Localizable

  func transitionToHome() {
    
    let homeViewController = storyboard?.instantiateViewController(identifier: Constants.K.homeViewController) as! UITabBarController
    
    view.window?.rootViewController = homeViewController
    view.window?.makeKeyAndVisible()
    
    present(homeViewController, animated: true, completion: nil)
    
  }
}

//MARK: - UITextField

extension LoginUserVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        passwordTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        return true
    }
}
