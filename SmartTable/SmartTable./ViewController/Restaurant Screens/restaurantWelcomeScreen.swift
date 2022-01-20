//
//  restaurantWelcomeScreen.swift
//  SmartTabel
//
//  Created by macbook air on 09/05/1443 AH.
//



import UIKit
import FirebaseAuth

class restaurantWelcomeScreen: UIViewController {
  
  // MAKR: - IBOutlet
  
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  
  //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
      self.dismissKeyboard()
      navigationItem.backButtonTitle = "Back"
      
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isUserSignedIn() {
            self.dismiss(animated: true,
                         completion: nil)
        }
    }
    
  //MARK: - Methode

    private func isUserSignedIn() -> Bool {
      return Auth.auth().currentUser != nil
    }
}
