//
//  CreateAccountForRestVC.swift
//  SmartTabel
//
//  Created by macbook air on 09/05/1443 AH.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateAccountForRestVC: UIViewController {
  
  @IBOutlet weak var nameTF: UITextField!
  @IBOutlet weak var emailTF: UITextField!
  @IBOutlet weak var passwordTF: UITextField!
  @IBOutlet weak var createAccountButton: UIButton!
  
  
  let db = Firestore.firestore()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
  }
  
  @IBAction func createAccount(_ sender: UIButton) {
    createAccountButtonTapped()
  }
  
  @objc private func createAccountButtonTapped() {
    guard let email = emailTF.text else {return}
    guard let password = passwordTF.text else {return}
    guard let name = nameTF.text else {return}
    
    if !email.isEmpty && !password.isEmpty && !name.isEmpty{
      signupUserUsing(email: email, password: password, name: name)
    }else{
      let alert = UIAlertController(title: "Oops!", message: "please make sure name, email and password are not empty.", preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      
      present(alert, animated: true)
    }
    
  }
  
  private func signupUserUsing(email: String, password: String, name: String) {
    Auth.auth().createUser(withEmail: email, password: password) { results, error in
      
      if let error = error as NSError? {
        switch AuthErrorCode(rawValue: error.code) {
        case .emailAlreadyInUse:
          
          let alert = UIAlertController(title: "Oops!", message: "email Already in use", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
          self.present(alert, animated: true)
          
        case .invalidEmail:
          
          let alert = UIAlertController(title: "Oops!", message: "are sure you typed the email correctly?", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
          self.present(alert, animated: true)
          
        case .weakPassword:
          
          let alert = UIAlertController(title: "Oops!", message: "Your password is weak, please make sure it's strong.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
          self.present(alert, animated: true)
          
        default:
          
          let alert = UIAlertController(title: "Oops!", message: "\(error.localizedDescription)", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
          self.present(alert, animated: true)
          
        }
      }else{
        guard let user = results?.user else {return}
        
        self.db.collection("RestaurantProfile").document(user.uid).setData([
          "name": name,
          "email": String(user.email!),
          "userID": user.uid,
        ], merge: true) { err in
          if let err = err {
            print("Error writing document: \(err)")
          } else {
            print("Document successfully written!")
//            self.navigationController?.popViewController(animated: true)
          }
          self.transitionToHome()
        }
        
        
      }
      
      
    }
  }
  
  func transitionToHome() {
    
    
    let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as! UIViewController
    
    view.window?.rootViewController = homeViewController
    view.window?.makeKeyAndVisible()
    
    present(homeViewController, animated: true, completion: nil)
    
  }
}

extension CreateAccountForRestVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    nameTF.resignFirstResponder()
    passwordTF.resignFirstResponder()
    emailTF.resignFirstResponder()
    return true
  }
}
