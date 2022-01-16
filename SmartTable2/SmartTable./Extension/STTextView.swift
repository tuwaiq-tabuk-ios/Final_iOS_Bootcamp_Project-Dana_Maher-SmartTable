//
//  STTextView.swift
//  SmartTabel
//
//  Created by macbook air on 09/05/1443 AH.
//

import UIKit

extension UITextView {
    open func setupTextView() {
        backgroundColor = .clear
        autocorrectionType = .no
        layer.cornerRadius = 13
        layer.borderWidth = 0.25
        layer.borderColor = UIColor.label.withAlphaComponent(0.5).cgColor
        clipsToBounds = true
        tintColor = UIColor(#colorLiteral(red: 0, green: 0.8117647059, blue: 0.9921568627, alpha: 1))
        translatesAutoresizingMaskIntoConstraints = false
        
    }
}
