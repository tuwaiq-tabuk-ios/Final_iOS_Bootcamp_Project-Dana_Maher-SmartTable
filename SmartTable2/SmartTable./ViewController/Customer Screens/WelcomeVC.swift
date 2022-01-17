//
//  WelcomeVC.swift
//  Twitterrr
//
//  Created by macbook air on 09/05/1443 AH.
//

import UIKit
import FirebaseAuth

class WelcomeVC: UIViewController {

  // MAKR: - IBOutlet
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var restaurantButton: UIButton!
  
  
  // view controoler lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
      self.dismissKeyboard()
      overrideUserInterfaceStyle = .light
    }

  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isUserSignedIn() {
            self.dismiss(animated: true, completion: nil)
        }
    }
  
  
    private func isUserSignedIn() -> Bool {
      return Auth.auth().currentUser != nil
    }
}
