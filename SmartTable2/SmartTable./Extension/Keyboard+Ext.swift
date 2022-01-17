//
//  KeyPoard+Ext.swift
//  SmartTable.
//
//  Created by macbook air on 06/06/1443 AH.
//

import UIKit

extension UIViewController {
  
  func dismissKeyboard() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self,
                                                              action:    #selector(UIViewController.dismissKeyboardTouchOutside))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc private func dismissKeyboardTouchOutside() {
    view.endEditing(true)
  }
}

