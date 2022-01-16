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

  
  func circularButton() {
      setImage(UIImage(systemName: "gearshape")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .medium)), for: .normal)
      layer.cornerRadius = 45 / 2
      clipsToBounds = true
      backgroundColor = UIColor(#colorLiteral(red: 0, green: 0.8117647059, blue: 0.9921568627, alpha: 1))
  }
}
