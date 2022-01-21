//
//  UserProfile.swift
//  SmartTabel
//
//  Created by macbook air on 06/01/2022.
//


import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class UserProfile: UIViewController {
  
  //MARK: - Properties
  
  let db = Firestore.firestore()
  
  
  let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(named: "Secondary Brand Fill Color")
    view.layer.cornerRadius = 13
    view.layer.cornerCurve = .continuous
    view.clipsToBounds = true
    return view
  }()
  
  let userNameLabel: UILabel = {
    let name = UILabel()
    name.font = UIFont.systemFont(ofSize: 29, weight: .bold)
    name.textColor = .black
    name.textAlignment = .center
    
    return name
  }()
  
  let signOutButton: UIButton = {
    let button = UIButton(type: .system)
    button.setupButton(with: "Sign out")
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  //MARK: - View Controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor(named: "Secondary Brand Fill Color")
    
    title = "User Profile"
    setUpLabels()
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    fetchCurrentUsers()
  }
  
  //MARK: - Functions
  
  func setUpLabels() {
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(containerView)
    
    containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    containerView.widthAnchor.constraint(equalToConstant: 325).isActive = true
    containerView.heightAnchor.constraint(equalToConstant: 155).isActive = true
    
    userNameLabel.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(userNameLabel)
    userNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
    userNameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    
    containerView.addSubview(signOutButton)
    
    signOutButton.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20).isActive = true
    signOutButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
    signOutButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
    signOutButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    signOutButton.addTarget(self, action: #selector(signOutButtonPressed), for: .touchUpInside)
  }
  
  //MARK: - IBActionsProgrammatically
  
  @objc func signOutButtonPressed(_ sender: UIButton) {
    do {
      try Auth.auth().signOut()
      if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC") as? UINavigationController {
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
      }
    } catch{
      print("ERROR in signout",error.localizedDescription)
    }
  }
  
  
  @objc func addDescriptionButtonPressed() {
    let sheetViewController = AddDescriptionVC(nibName: nil, bundle: nil)
    self.present(sheetViewController, animated: true, completion: nil)
  }
  
  //MARK: - Methode
  
  private func fetchCurrentUsers() {
    guard let currentUser = FirebaseAuth.Auth.auth().currentUser else {return}
    db.collection("UserProfile").whereField("userID", isEqualTo: currentUser.uid)
      .addSnapshotListener { (querySnapshot, error) in
        if let e = error {
          print("There was an issue retrieving data from Firestore. \(e)")
        } else {
          if let snapshotDocuments = querySnapshot?.documents {
            print(snapshotDocuments)
            for doc in snapshotDocuments {
              let data = doc.data()
              if let userName = data["name"] as? String
              {
                DispatchQueue.main.async {
                  self.userNameLabel.text = userName
                }
              }
            }
          }
        }
      }
  }
}

