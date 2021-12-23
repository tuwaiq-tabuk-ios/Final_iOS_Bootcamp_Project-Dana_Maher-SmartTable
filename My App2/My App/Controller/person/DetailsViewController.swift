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
  override func viewDidLoad() {
        super.viewDidLoad()

    }
    
  @IBAction func cancelButtonItem(_ sender: UIBarButtonItem) {
    let isPresentingInAddMode = presentingViewController is UINavigationController
    if isPresentingInAddMode {
      dismiss(animated: true, completion: nil)
    }else{
      navigationController?.popViewController(animated: true)
    }
    
  }
  
}
