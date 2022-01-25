//
//  CreateAccountVC.swift
//  Twitterrr
//
//  Created by macbook air on 09/05/1443 AH.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateAccountForUserVC: UIViewController {
  
  //MARK: - Properties
  
  let db = Firestore.firestore()
  
  // MAKR: - IBOutlet
  @IBOutlet weak var nameTF: UITextField!
  @IBOutlet weak var emailTF: UITextField!
  @IBOutlet weak var passwordTF: UITextField!
  @IBOutlet weak var confirmPasswordTF: UITextField!
  @IBOutlet weak var createAccountButton: UIButton!
  
  //MARK: - View Controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.dismissKeyboard()
    navigationItem.backButtonTitle = "Back"
    
    createAccountButton.addTarget(self,
                                  action: #selector(createUser),
                                  for: .touchUpInside)
    
    nameTF.delegate = self
    emailTF.delegate = self
    passwordTF.delegate = self
    confirmPasswordTF.delegate = self
  }
  
  //MARK: - IBActions
  
  @IBAction func createUser(_ sender: UIButton) {
    createAccount()
  }
  
  
  private func createAccount() {
    guard let email = emailTF.text else { return }
    guard let password = passwordTF.text else { return }
    guard let name = nameTF.text else { return }
    guard let confirmPassword = confirmPasswordTF.text else { return }
    
    print("DEBUG: name: \(name)")
    
    if !email.isEmpty && !password.isEmpty && !name.isEmpty {
      if passwordTF.text == confirmPasswordTF.text {
        signupUserUsing(email: email,
                        password: password,
                        name: name, confirmPassword: confirmPassword)      } else {
        
        let alert = UIAlertController(title: "Oops!",
                                      message: "The password is not available",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: nil))
        
        present(alert,
                animated: true)
        
      }
    } else {
      let alert = UIAlertController(title: "Oops!",
                                    message: "please make sure name, email and password are not empty.",
                                    preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(title: "OK",
                                    style: .cancel,
                                    handler: nil))
      present(alert,
              animated: true)
    }
    
  }
  
  //MARK: - Methode
  
  private func signupUserUsing(email: String,
                               password: String,
                               name: String,confirmPassword: String) {
    
    FSUserManager.shared.signUpUserWith(email: email,
                                        password: password,
                                        name: name, confirmPassword: confirmPassword) { error in
   
      print("DEBUG: \(#function) - error: \(String(describing: error))")
      
      if error == nil{
        print("DEBUG: ----Document successfully written!")
        self.transitionToHome()
      } else {
        print("DEBUG: ---- error: \(String(describing: error?.localizedDescription))")
        let alert = UIAlertController(title: "Oops!",
                                      message: error?.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: nil))
        self.present(alert,
                     animated: true)
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

extension CreateAccountForUserVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    nameTF.resignFirstResponder()
    passwordTF.resignFirstResponder()
    emailTF.resignFirstResponder()
    confirmPasswordTF.resignFirstResponder()
    return true
  }
}
