//
//  ViewController.swift
//  My App
//
//  Created by macbook air on 05/05/1443 AH.
//

import UIKit

class ViewController: UIViewController {
 

  @IBOutlet weak var visitorBottom: UIButton!
  
  @IBOutlet weak var businessBottom: UIButton!
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  setUpElements()
    
  }
  
  
  func setUpElements() {
    Utilities.styleFilledButton(visitorBottom)
    Utilities.styleFilledButton(businessBottom)
    
  }
  
  
}

