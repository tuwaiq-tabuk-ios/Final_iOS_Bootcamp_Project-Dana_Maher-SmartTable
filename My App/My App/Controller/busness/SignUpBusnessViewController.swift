//
//  SignUpBusnessViewController.swift
//  My App
//
//  Created by macbook air on 11/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpBusnessViewController: UIViewController {
  
  
  @IBOutlet weak var resturantOfName: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var paswwordTextField: UITextField!
  @IBOutlet weak var signUp: UIButton!
  @IBOutlet weak var errorLable: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpElements()
    
  }
  
  
  func setUpElements() {
    
    errorLable.alpha = 0
    
    Utilities.styleTextField(resturantOfName)
    Utilities.styleTextField(emailTextField)
    Utilities.styleTextField(paswwordTextField)
    
    Utilities.styleFilledButton(signUp)
    
    
  }
  
  
  func validateFields() -> String? {
    
    if resturantOfName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || paswwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    {
      
      return "Please fill in all fiellds."
      
    }
    
    let cleanedPassword = paswwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if Utilities.isPasswordValid(cleanedPassword) == false {
      
      return "Please make sure your password is at least 8 characters, contains a special character and a number."
    }
    
    return nil
  }
  
  
  @IBAction func signUp(_ sender: Any) {
    
    
    let error = validateFields()
    
    if error != nil {
      
      showError(error!)
      
    }
    else {
      
      let restaurntname = resturantOfName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let password = paswwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      
      Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
        
        if err != nil {
          
          
          self.showError("Error creating user")
          
        }
        
        else {
          
          
          let db = Firestore.firestore()
          
          db.collection("user").addDocument(data: ["resturantName": restaurntname, "uid": result!.user.uid]) { (error) in
            
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
    
    
    let homeViewController = storyboard?.instantiateViewController(identifier: constant.Storyboard.homeViewController) as? HomeViewController
    
    view.window?.rootViewController = homeViewController
    view.window?.makeKeyAndVisible()
    
  }
  
}
