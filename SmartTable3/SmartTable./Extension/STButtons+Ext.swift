//
//  STButtons.swift
//  SmartTabel
//
//  Created by macbook air on 09/05/1443 AH.
//


import UIKit


extension UIButton {
    open func setupButton(with title: String) {
        backgroundColor = UIColor(#colorLiteral(red: 0, green: 0.8117647059, blue: 0.9921568627, alpha: 1))
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 13
        clipsToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.25
        translatesAutoresizingMaskIntoConstraints = false
    }
  
  
    open func setupButton(using image: String) {
        setImage(UIImage(systemName: image)?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        backgroundColor = .systemOrange
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
