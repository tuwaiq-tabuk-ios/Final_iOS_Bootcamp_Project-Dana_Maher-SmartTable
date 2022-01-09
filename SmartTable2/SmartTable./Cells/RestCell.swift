//
//  RestCell.swift
//  SmartTabel
//
//  Created by macbook air on 09/05/1443 AH.
//

import UIKit
import FirebaseStorage

class RestCell: UITableViewCell {
    
    static let id = "cell"
    
    
  
  
    
   
  lazy var storeImage: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    let stroeName: UILabel = {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return $0
    }(UILabel())
    let storeEmail : UILabel = {
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
        setupView()
    }
    private func setupView() {
        self.clipsToBounds = true
        storeImage.translatesAutoresizingMaskIntoConstraints = false
        stroeName.translatesAutoresizingMaskIntoConstraints = false
        storeEmail.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(storeImage)
        contentView.addSubview(stroeName)
        contentView.addSubview(storeEmail)
        NSLayoutConstraint.activate([
            storeImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            storeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            storeImage.heightAnchor.constraint(equalToConstant: 65),
            storeImage.widthAnchor.constraint(equalToConstant: 65),
            stroeName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stroeName.leadingAnchor.constraint(equalTo: storeImage.trailingAnchor, constant: 10),
            stroeName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            storeEmail.topAnchor.constraint(equalTo: stroeName.bottomAnchor, constant: 10),
            storeEmail.leadingAnchor.constraint(equalTo: storeImage.trailingAnchor, constant: 10),
            storeEmail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    
}


