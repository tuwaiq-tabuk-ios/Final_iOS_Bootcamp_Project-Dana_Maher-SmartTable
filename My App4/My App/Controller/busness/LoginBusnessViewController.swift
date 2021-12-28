//
//  LoginBusnessViewController.swift
//  My App
//
//  Created by macbook air on 11/05/1443 AH.
//

import UIKit
import FirebaseAuth

class LoginBusnessViewController: UIViewController {
  
  
  @IBOutlet weak var iDRestaurantTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!

  @IBOutlet weak var login: UIButton!
  @IBOutlet weak var errorLable: UILabel!
  
  
  override func viewDidLoad() {
        super.viewDidLoad()

    setUpElements()
    }
  
  
  func setUpElements() {
    
    errorLable.alpha = 0
    
    Utilities.styleTextField(iDRestaurantTextField)
    Utilities.styleTextField(passwordTextField)
    Utilities.styleFilledButton(login)
  
  }
    

   
  @IBAction func loginTapped(_ sender: Any) {
    
    let restaurantID = iDRestaurantTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    
    Auth.auth().signIn(withEmail: restaurantID, password: password) { (result, error) in
      if error != nil {
        
        self.errorLable.text = error!.localizedDescription
        self.errorLable.alpha = 1
      }
      else {
        
        let homeViewController = self.storyboard?.instantiateViewController(identifier: constant.Storyboard.homeViewController) as? HomeViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
      }
    }
  }
  
}

