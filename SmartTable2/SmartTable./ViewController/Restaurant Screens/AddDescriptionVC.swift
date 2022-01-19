//
//  AddDescriptionVC.swift
//  SmartTabel
//
//  Created by macbook air on 05/01/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddDescriptionVC: UIViewController {
  
  //MARK: - Properties

    let db = Firestore.firestore()
    
    let limitLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.textColor = .black.withAlphaComponent(0.57)
        lbl.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Your Desciption: characters Limit "
        return lbl
    }()
    
    let restTV: UITextView = {
        let tf = UITextView()
        tf.setupTextView()
        return tf
    }()
    
    let restButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setupButton(with: "Add")
        
        return btn
    }()
    
  //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
      self.dismissKeyboard()
          navigationItem.setHidesBackButton(true,
                                            animated: true)
  
        view.backgroundColor = .stBackground
        setupPresenetationMode()
        setupView()
    }

  //MARK: - Methode

    private func setupPresenetationMode() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium(),
                .large()
            ]
            presentationController.prefersGrabberVisible = true
        }
    }
    
  
    private func setupView() {
        view.addSubview(limitLabel)
        view.addSubview(restTV)
        view.addSubview(restButton)
        restTV.delegate = self
        restButton.addTarget(self,
                             action: #selector(sendDescription),
                             for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            limitLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            limitLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -20),
            limitLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: 20),
            limitLabel.heightAnchor.constraint(equalToConstant: 35),
            
            restTV.topAnchor.constraint(equalTo: limitLabel.bottomAnchor,
                                        constant: 0),
            restTV.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                             constant: -20),
            restTV.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                            constant: 20),
            restTV.heightAnchor.constraint(equalToConstant: 80),
            restButton.topAnchor.constraint(equalTo: restTV.bottomAnchor,
                                            constant: 5),
            restButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -20),
            restButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: 20),
            restButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
  
  
    @objc private func sendDescription() {
        guard let userNewText = restTV.text else {
          return
          
        }
        guard let currentUser = Auth.auth().currentUser else {
          return
        }
      
        self.db.collection("RestaurantProfile").document(currentUser.uid).setData([
            "restaurantDescription": userNewText
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                DispatchQueue.main.async {
                    self.dismiss(animated: true,
                                 completion: nil)
                }
            }
        }
    }
    
}

//MARK: - UITextView

extension AddDescriptionVC: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
      
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range,
                                      in: currentText) else {
          return false
          
        }
      
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        limitLabel.text = "Your Description: characters Limit " + "80/" + "\(updatedText.count - 1)"
        return updatedText.count <= 80
    }
}
