//
//  STButtons.swift
//  SmartTabel
//
//  Created by macbook air on 09/05/1443 AH.
//


import UIKit


extension UIButton {
  
  open func setupButton(with title: String) {
    backgroundColor = .gray
      setTitle(title, for: .normal)
      setTitleColor(.white, for: .normal)
      layer.cornerRadius = 13
      clipsToBounds = true
      layer.borderColor = UIColor.white.cgColor
      layer.borderWidth = 0.25
      translatesAutoresizingMaskIntoConstraints = false
  }

  //MARK: - Functions

  func circularButton() {
      setImage(UIImage(systemName: "gearshape")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .medium)), for: .normal)
      layer.cornerRadius = 45 / 2
      clipsToBounds = true
    backgroundColor = .gray
  }
}
