//
//  RestCell.swift
//  SmartTabel
//
//  Created by macbook air on 04/01/2022.
//

import UIKit
import FirebaseStorage

class RestaurantCell: UITableViewCell {
    
  static let id = "cell"
  
  lazy var restImage: UIImageView = {
      $0.contentMode = .scaleAspectFill
      $0.layer.cornerRadius = 10
      $0.clipsToBounds = true
      return $0
  }(UIImageView())
  
  let restName: UILabel = {
      $0.textColor = .black
      $0.textAlignment = .left
      $0.numberOfLines = 0
      $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
      return $0
  }(UILabel())
  
  let restEmail : UILabel = {
      $0.textColor = .black
      $0.numberOfLines = 0
      $0.textAlignment = .left
      $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
      return $0
  }(UILabel())
  
  
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")

  }
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = UIColor(named: "Secondary Brand Fill Color")

      setupView()
  }
  
  //MARK: - Methode

  private func setupView() {
      self.clipsToBounds = true
      restImage.translatesAutoresizingMaskIntoConstraints = false
      restName.translatesAutoresizingMaskIntoConstraints = false
      restEmail.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(restImage)
      contentView.addSubview(restName)
      contentView.addSubview(restEmail)
      NSLayoutConstraint.activate([
          restImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
          restImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
          restImage.heightAnchor.constraint(equalToConstant: 65),
          restImage.widthAnchor.constraint(equalToConstant: 65),
          restName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
          restName.leadingAnchor.constraint(equalTo: restImage.trailingAnchor, constant: 10),
          restName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
          restEmail.topAnchor.constraint(equalTo: restName.bottomAnchor, constant: 10),
          restEmail.leadingAnchor.constraint(equalTo: restImage.trailingAnchor, constant: 10),
          restEmail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      ])
  }
}


