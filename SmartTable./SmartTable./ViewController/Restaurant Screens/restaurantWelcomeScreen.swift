//
//  restaurantWelcomeScreen.swift
//  SmartTabel
//
//  Created by macbook air on 09/05/1443 AH.
//



import UIKit
import FirebaseAuth

class restaurantWelcomeScreen: UIViewController {
  
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  
  

//    let illustrationImage: UIImageView = {
//        let image = UIImageView()
//        image.image = UIImage(named: "bg")
//        image.contentMode = .scaleAspectFit
//        image.clipsToBounds = true
//        image.translatesAutoresizingMaskIntoConstraints = false
//        return image
//    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
