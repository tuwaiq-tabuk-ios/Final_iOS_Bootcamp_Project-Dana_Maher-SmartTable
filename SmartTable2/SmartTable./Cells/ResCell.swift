//
//  ResCell.swift
//  SmartTable.
//
//  Created by macbook air on 10/06/1443 AH.
//

import UIKit
import FirebaseStorage

class ResCell: UITableViewCell {
    
    static let id = "cell123"
    
    
    
    
    let dateLbl: UILabel = {
        $0.textColor = .black.withAlphaComponent(0.5)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        return $0
    }(UILabel())
  
    let emailLbl: UILabel = {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return $0
    }(UILabel())
  
    let nameLbl: UILabel = {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return $0
    }(UILabel())
  
    let nosLbl: UILabel = {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return $0
    }(UILabel())
    
    let seatLbl : UILabel = {
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return $0
    }(UILabel())
  
    let sectionLbl: UILabel = {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return $0
    }(UILabel())
    
    let locationLabel: UILabel = {
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        $0.backgroundColor = UIColor(#colorLiteral(red: 0, green: 0.8117647059, blue: 0.9921568627, alpha: 1))
        $0.text = "GO TO LOCATION"
        $0.layer.cornerRadius = 11
        $0.clipsToBounds = true
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
        
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        emailLbl.translatesAutoresizingMaskIntoConstraints = false
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        nosLbl.translatesAutoresizingMaskIntoConstraints = false
        seatLbl.translatesAutoresizingMaskIntoConstraints = false
        sectionLbl.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLbl)
        contentView.addSubview(emailLbl)
        contentView.addSubview(nameLbl)
        contentView.addSubview(nosLbl)
        contentView.addSubview(seatLbl)
        contentView.addSubview(sectionLbl)
        contentView.addSubview(            locationLabel)
        NSLayoutConstraint.activate([
            
            
            locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            locationLabel.widthAnchor.constraint(equalToConstant: 110),
            locationLabel.heightAnchor.constraint(equalToConstant: 35),
            
            dateLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            dateLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dateLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nameLbl.topAnchor.constraint(equalTo: dateLbl.bottomAnchor, constant: 5),
            nameLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            
            emailLbl.topAnchor.constraint(equalTo: nameLbl.bottomAnchor, constant: 10),
            emailLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            emailLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nosLbl.topAnchor.constraint(equalTo: emailLbl.bottomAnchor, constant: 10),
            nosLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nosLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            seatLbl.topAnchor.constraint(equalTo: nosLbl.bottomAnchor, constant: 10),
            seatLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            seatLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            sectionLbl.topAnchor.constraint(equalTo: seatLbl.bottomAnchor, constant: 10),
            sectionLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            sectionLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            
        ])
        
    }
    
    
}



