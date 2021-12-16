//
//  SignUpViewController.swift
//  My App
//
//  Created by macbook air on 09/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore


class SignUpViewController: UIViewController {
  
  @IBOutlet weak var firstnameTextField: UITextField!
  @IBOutlet weak var lastnameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var signUp: UIButton!
  
  @IBOutlet weak var errorLable: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    
    setUpElements()
    
  }
  func setUpElements() {
    
    errorLable.alpha = 0
    
    Utilities.styleTextField(firstnameTextField)
    Utilities.styleTextField(lastnameTextField)
    Utilities.styleTextField(emailTextField)
    Utilities.styleTextField(passwordTextField)
    
    Utilities.styleFilledButton(signUp)
    
    
  }
  
  
  func validateFields() -> String? {
    
    if firstnameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastnameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    {
      
      return "Please fill in all fiellds."
      
    }
    
    let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if Utilities.isPasswordValid(cleanedPassword) == false {
      
      return "Please make sure your password is at least 8 characters, contains a special character and a number."
    }
    
    return nil
  }
  
  @IBAction func signUTapped(_ sender: Any) {
    
    let error = validateFields()
    
    if error != nil {
      
      showError(error!)
      
    }
    else {
      
      let firstName = firstnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let lastname = lastnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      
      Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
        
        if err != nil {
          
          
          self.showError("Error creating user")
          
        }
        
        else {
           
          
          let db = Firestore.firestore()
          
          db.collection("users").addDocument(data: ["firstname": firstName, "lastname": lastname, "uid": result!.user.uid]) { (error) in
            
            if error != nil {
              
              self.showError("Error saving user data")
              
            }
          }
          
          self.transitionToHome()
          
        }
      }
    }
  }
  
  func showError(_ message: String) {
    
    errorLable.text = message
    errorLable.alpha = 1
  }
  
  
  func transitionToHome() {
    
    
    let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? TabBarViewController
    
    view.window?.rootViewController = homeViewController
    view.window?.makeKeyAndVisible()
    
  }
  
}

