//
//  STTextField.swift
//  SmartTabel
//
//  Created by Faisal on 04/01/2022.
//

import UIKit


import UIKit

extension UITextField {
  
    open func setupTextField(with placeholder: NSAttributedString) {
        backgroundColor = .clear
        autocorrectionType = .no
        layer.cornerRadius = 13
        layer.borderWidth = 0.25
        layer.borderColor = UIColor.label.withAlphaComponent(0.5).cgColor
        clipsToBounds = true
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        leftViewMode = .always
        attributedPlaceholder = placeholder
        tintColor = .label
        textColor = .label
        translatesAutoresizingMaskIntoConstraints = false
    }

}

