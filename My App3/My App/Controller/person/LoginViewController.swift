//
//  LoginViewController.swift
//  My App
//
//  Created by macbook air on 09/05/1443 AH.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
  
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextFiled: UITextField!
  
  @IBOutlet weak var login: UIButton!
  
  @IBOutlet weak var errorLable: UILabel!
  
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    setUpElements()
    
    }
  func setUpElements() {
    
    errorLable.alpha = 0
    
    Utilities.styleTextField(emailTextField)
    Utilities.styleTextField(passwordTextFiled)
    Utilities.styleFilledButton(login)
  
  }

  
  
  
  @IBAction func loginTapped(_ sender: Any) {
    
    let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let password = passwordTextFiled.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      if error != nil {
        
        self.errorLable.text = error!.localizedDescription
        self.errorLable.alpha = 1
      }
      else {
        
        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? TabBarViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
      }
    }
  }
  
}
