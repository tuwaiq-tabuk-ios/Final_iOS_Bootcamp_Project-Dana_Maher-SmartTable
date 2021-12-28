//
//  DetailsViewController.swift
//  My App
//
//  Created by macbook air on 19/05/1443 AH.
//

import UIKit

class DetailsViewController: UIViewController {
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var addressTextField: UITextField!
  @IBOutlet weak var ratingLable: UILabel!
  
  var spot: Spot!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    if spot == nil{
      spot = Spot()
    }
    
    updateUserInterface()
    
  }
  
  
  func updateUserInterface(){
    nameTextField.text = spot.name
    addressTextField.text = spot.address
  }
  
  
  func updateFromInterface(){
    spot.name = nameTextField.text!
    spot.address = addressTextField.text!
  }
  
  
  func leaveViewController(){

    let isPresentingInAddMode = presentingViewController is UINavigationController
    if isPresentingInAddMode {
      dismiss(animated: true, completion: nil)
    }else{
      navigationController?.popViewController(animated: true)
    }

  }
  
  
  @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    updateFromInterface()
    spot.saveData { (success) in
      if success {
        self.leaveViewController()
      }else{
        self.oneButtonAlert(title: "save Failed", message: "For some reson, the data would not save to the cloud")
        
      }
    }
    
  }
  
  
  
  @IBAction func cancelButtonItem(_ sender: UIBarButtonItem) {
    leaveViewController()
  }
  
}
