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
  
  let nameTF: UITextField = {
    let textField = UITextField()
    textField.setupTextField(with:  NSAttributedString(string: "Your name",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.5)]))
    
    return textField
  }()
  
  let emailTF: UITextField = {
    let textField = UITextField()
    textField.setupTextField(with:  NSAttributedString(string: "Email",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.5)]))
    
    return textField
  }()
  
  let passwordTF: UITextField = {
    let textField = UITextField()
    textField.setupTextField(with:  NSAttributedString(string: "password",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.5)]))
    textField.isSecureTextEntry = true
    return textField
  }()
  
  let confirmPasswordTF: UITextField = {
    let textField = UITextField()
    textField.setupTextField(with:  NSAttributedString(string: "ConfirmPassword",
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.label.withAlphaComponent(0.5)]))
    textField.isSecureTextEntry = true
    return textField
  }()
  
  let createAccountButton: UIButton = {
    let button = UIButton(type: .system)
    button.setupButton(with: "Create Account")
    return button
  }()
  
  //MARK: - View Controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.dismissKeyboard()
    navigationItem.backButtonTitle = "Back"
    
    
    setupViews()
  }
  
  //MARK: - Methode
  
  private func setupViews() {
    view.addSubview(nameTF)
    view.addSubview(emailTF)
    view.addSubview(passwordTF)
    view.addSubview(confirmPasswordTF)
    view.addSubview(createAccountButton)
    
    createAccountButton.addTarget(self,
                                  action: #selector(createAccountButtonPressed),
                                  for: .touchUpInside)
    
    nameTF.delegate = self
    emailTF.delegate = self
    passwordTF.delegate = self
    confirmPasswordTF.delegate = self
    
    NSLayoutConstraint.activate([
      
      createAccountButton.bottomAnchor
        .constraint(equalTo: view.bottomAnchor, constant: -240),
      createAccountButton.leadingAnchor
        .constraint(equalTo: view.leadingAnchor, constant: 20),
      createAccountButton.trailingAnchor
        .constraint(equalTo: view.trailingAnchor, constant: -20),
      createAccountButton.heightAnchor
        .constraint(equalToConstant: 45),
      
      passwordTF.bottomAnchor
        .constraint(equalTo: confirmPasswordTF.topAnchor, constant: -20),
      passwordTF.leadingAnchor
        .constraint(equalTo: view.leadingAnchor, constant: 20),
      passwordTF.trailingAnchor
        .constraint(equalTo: view.trailingAnchor, constant: -20),
      passwordTF.heightAnchor
        .constraint(equalToConstant: 45),
      
      emailTF.bottomAnchor
        .constraint(equalTo: passwordTF.topAnchor, constant: -20),
      emailTF.leadingAnchor
        .constraint(equalTo: view.leadingAnchor, constant: 20),
      emailTF.trailingAnchor
        .constraint(equalTo: view.trailingAnchor, constant: -20),
      emailTF.heightAnchor
        .constraint(equalToConstant: 45),
      
      nameTF.bottomAnchor
        .constraint(equalTo: emailTF.topAnchor, constant: -20),
      nameTF.leadingAnchor
        .constraint(equalTo: view.leadingAnchor, constant: 20),
      nameTF.trailingAnchor
        .constraint(equalTo: view.trailingAnchor, constant: -20),
      nameTF.heightAnchor
        .constraint(equalToConstant: 45),
      
      confirmPasswordTF.bottomAnchor
        .constraint(equalTo: createAccountButton.topAnchor, constant: -20),
      confirmPasswordTF.leadingAnchor
        .constraint(equalTo: view.leadingAnchor, constant: 20),
      confirmPasswordTF.trailingAnchor
        .constraint(equalTo: view.trailingAnchor, constant: -20),
      confirmPasswordTF.heightAnchor
        .constraint(equalToConstant: 45)
      
    ])
  }
  
  //MARK: - IBActions
  
  @objc private func createAccountButtonPressed() {
    guard let email = emailTF.text else {return}
    guard let password = passwordTF.text else {return}
    guard let name = nameTF.text else {return}
    guard let confirmPassword = confirmPasswordTF.text else { return }
    
    
    if !email.isEmpty && !password.isEmpty && !name.isEmpty{
      if passwordTF.text == confirmPasswordTF.text {
        signupUserUsing(email: email, password: password, name: name)
        
      } else {
        
        let alert = UIAlertController(title: "Oops!",
                                      message: "The password is not Match",
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
  
  
  private func signupUserUsing(email: String,
                               password: String,
                               name: String) {
    Auth.auth().createUser(withEmail: email,
                           password: password) { results, error in
      
      if let error = error as NSError? {
        switch AuthErrorCode(rawValue: error.code) {
        case .emailAlreadyInUse:
          
          let alert = UIAlertController(title: "Oops!",
                                        message: "email Already in use",
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
          
        case .weakPassword:
          
          let alert = UIAlertController(title: "Oops!",
                                        message: "Your password is weak, please make sure it's strong.",
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
          "name": name,
          "email": String(user.email!),
          "userID": user.uid,
          "isRest": "no"
        ], merge: true) { err in
          if let err = err {
            print("Error writing document: \(err)")
          } else {
            print("Document successfully written!")
            self.transitionToHome()
          }
        }
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
