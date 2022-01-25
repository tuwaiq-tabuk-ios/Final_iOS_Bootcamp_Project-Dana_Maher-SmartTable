//
//  AddReservationVC.swift
//  SmartTabel
//
//  Created by macbook air on 09/06/1443 AH.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddReservationVC: UIViewController {
  
  //MARK: - Properties

    private let db = Firestore.firestore()
    private let numberOfSeatsPicker = UIPickerView()
    private let datePicker = UIDatePicker()
    
    private var UserChoseWithFamily = "single"
    private var UserChoseIndoors = "indoors"
    private var UserChoseSeatsNumber = "1"
    private var UserChoseDate = ""
    var restaurantName: String? 
    var restaurantID: String?
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black.withAlphaComponent(0.57)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "RESERVE A TABLE"
        return lbl
    }()
    
    private let userNameLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.textColor = .black.withAlphaComponent(0.57)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
  
    private let userEmailLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black.withAlphaComponent(0.57)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let inOrOutsideLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.textColor = .black.withAlphaComponent(0.57)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.layer.cornerRadius = 13
        lbl.clipsToBounds = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Do you prefer to eat outdoors?"
        return lbl
    }()
    
    private let inOrOutsideSwitch: UISwitch = {
        let switchbtn = UISwitch()
        switchbtn.tintColor = .systemGray6
        switchbtn.thumbTintColor = UIColor(#colorLiteral(red: 0, green: 0.8117647059, blue: 0.9921568627, alpha: 1))
        switchbtn.onTintColor = UIColor(#colorLiteral(red: 0, green: 0.8117647059, blue: 0.9921568627, alpha: 0.25))
        switchbtn.addTarget(self, action: #selector(switchForInsideOrOutsideValueDidChange(_:)), for: .valueChanged)
        switchbtn.translatesAutoresizingMaskIntoConstraints = false
        
        return switchbtn
    }()
    
    private let signleOrFamilyLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.textColor = .black.withAlphaComponent(0.57)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.layer.cornerRadius = 13
        lbl.clipsToBounds = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Are you with your family?"
        return lbl
    }()
    
    private let signleOrFamilySwitch: UISwitch = {
        let switchbtn = UISwitch()
        switchbtn.tintColor = .systemGray6
        switchbtn.thumbTintColor = UIColor(#colorLiteral(red: 0,
                                                         green: 0.8117647059,
                                                         blue: 0.9921568627,
                                                         alpha: 1))
        switchbtn.onTintColor = UIColor(#colorLiteral(red: 0,
                                                      green: 0.8117647059,
                                                      blue: 0.9921568627,
                                                      alpha: 0.25))
        switchbtn.addTarget(self,
                            action: #selector(switchForsignleOrFamilyDidChange(_:)),
                            for: .valueChanged)
        switchbtn.translatesAutoresizingMaskIntoConstraints = false
        return switchbtn
    }()
    
    private let restButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setupButton(with: "Add")
        return btn
    }()
  
  //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPresenetationMode()
        setupView()
        setupDatePicker()
        fetchCurrentUsers()
        numberOfSeatsPicker.dataSource = self
        numberOfSeatsPicker.delegate = self
      
      view.backgroundColor = UIColor(named: "Secondary Brand Fill Color")
    }
    
  
    @objc private func switchForInsideOrOutsideValueDidChange(_ sender: UISwitch) {
        if (sender.isOn){
            print("on for outside")
            UserChoseIndoors = "Outdoors"
        }
        else {
            print("on for inside")
            UserChoseIndoors = "Indoors"
        }
    }
  
  
    @objc private func switchForsignleOrFamilyDidChange(_ sender: UISwitch) {
        if (sender.isOn){
            print("with family")
            UserChoseWithFamily = "Family"
        }
        else {
            print("single")
            UserChoseWithFamily = "Single"
        }
    }
  
  //MARK: - Methode

    private func setupPresenetationMode() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium(),
                .large()
            ]
            presentationController.prefersGrabberVisible = true
        }
    }
  
  
    private func setupDatePicker() {
        datePicker.calendar = .current
        datePicker.datePickerMode = .date
        
        datePicker.addTarget(self,
                             action: #selector(datePickerChanged(_:)),
                             for: .valueChanged)
    }
  
  
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "E, d MMM"
        
        UserChoseDate = dateFormatter.string(from: sender.date)
    }
    
  //MARK: - Methode

    private func fetchCurrentUsers() {
        guard let currentUserName = FirebaseAuth.Auth.auth().currentUser else {return}
        db.collection("UserProfile").whereField("email",
                                                isEqualTo: String(currentUserName.email!))
            .addSnapshotListener { (querySnapshot, error) in
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let userName = data["name"] as? String,
                               let userEmail = data["email"] as? String
                            {
                                
                                
                                DispatchQueue.main.async {
                                    self.userNameLabel.text = userName
                                    self.userEmailLabel.text = userEmail
                                    
                                }
                                
                                
                            }
                        }
                    }
                }
                
            }
    }
    
  
    private func setupView() {
        
        numberOfSeatsPicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
      
        view.addSubview(titleLabel)
        view.addSubview(numberOfSeatsPicker)
        view.addSubview(restButton)
        view.addSubview(userNameLabel)
        view.addSubview(userEmailLabel)
        view.addSubview(signleOrFamilyLabel)
        view.addSubview(inOrOutsideLabel)
        view.addSubview(signleOrFamilySwitch)
        view.addSubview(inOrOutsideSwitch)
        view.addSubview(datePicker)
 
        restButton.addTarget(self,
                             action: #selector(sendReservation),
                             for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor
              .constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor
              .constraint(equalTo: view.leadingAnchor, constant: 20),
            
            userNameLabel.topAnchor
              .constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            userNameLabel.leadingAnchor
              .constraint(equalTo: view.leadingAnchor, constant: 20),
            userNameLabel.trailingAnchor
              .constraint(equalTo: view.trailingAnchor, constant: -20),
            userNameLabel.heightAnchor
              .constraint(equalToConstant: 45),
            
            
            userEmailLabel.topAnchor
              .constraint(equalTo: userNameLabel.bottomAnchor, constant: 15),
            userEmailLabel.leadingAnchor
              .constraint(equalTo: view.leadingAnchor, constant: 20),
            userEmailLabel.trailingAnchor
              .constraint(equalTo: view.trailingAnchor, constant: -20),
            userEmailLabel.heightAnchor
              .constraint(equalToConstant: 45),
            
            signleOrFamilyLabel.topAnchor
              .constraint(equalTo: userEmailLabel.bottomAnchor, constant: 15),
            signleOrFamilyLabel.leadingAnchor
              .constraint(equalTo: view.leadingAnchor, constant: 20),
            signleOrFamilyLabel.heightAnchor
              .constraint(equalToConstant: 45),
            
            
            
            signleOrFamilySwitch.topAnchor
              .constraint(equalTo: userEmailLabel.bottomAnchor, constant: 15),
            signleOrFamilySwitch.trailingAnchor
              .constraint(equalTo: view.trailingAnchor, constant: -20),
            signleOrFamilySwitch.heightAnchor
              .constraint(equalToConstant: 45),
            
            inOrOutsideLabel.topAnchor
              .constraint(equalTo: signleOrFamilyLabel.bottomAnchor, constant: 15),
            inOrOutsideLabel.leadingAnchor
              .constraint(equalTo: view.leadingAnchor, constant: 20),
            inOrOutsideLabel.heightAnchor
              .constraint(equalToConstant: 45),
            
            inOrOutsideSwitch.topAnchor
              .constraint(equalTo: signleOrFamilyLabel.bottomAnchor, constant: 15),
            inOrOutsideSwitch.trailingAnchor
              .constraint(equalTo: view.trailingAnchor, constant: -20),
            inOrOutsideSwitch.heightAnchor
              .constraint(equalToConstant: 45),
            
            numberOfSeatsPicker.topAnchor
              .constraint(equalTo: inOrOutsideSwitch.bottomAnchor, constant: 35),
            numberOfSeatsPicker.leadingAnchor
              .constraint(equalTo: view.leadingAnchor, constant: 20),
            numberOfSeatsPicker.trailingAnchor
              .constraint(equalTo: view.trailingAnchor, constant: -20),
            numberOfSeatsPicker.heightAnchor
              .constraint(equalToConstant: 75),
            
            
            datePicker.topAnchor
              .constraint(equalTo: numberOfSeatsPicker.bottomAnchor, constant: 15),
            datePicker.leadingAnchor
              .constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor
              .constraint(equalTo: view.trailingAnchor, constant: -20),
            
            restButton.topAnchor
              .constraint(equalTo: datePicker.bottomAnchor, constant: 25),
            restButton.trailingAnchor
              .constraint(equalTo: view.trailingAnchor, constant: -20),
            restButton.leadingAnchor
              .constraint(equalTo: view.leadingAnchor, constant: 20),
            restButton.heightAnchor
              .constraint(equalToConstant: 45),
        ])
    }
  
  
    @objc private func sendReservation() {
        guard let user = Auth.auth().currentUser else {return}
        var location = ""
        if UserChoseIndoors.isEmpty || UserChoseWithFamily.isEmpty || UserChoseSeatsNumber.isEmpty || UserChoseDate.isEmpty {
            let alert = UIAlertController(title: "Something went wrong!",
                                          message: "Please make sure you completed all reservation fields.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .cancel,
                                          handler: nil))
            self.present(alert,
                         animated: true)
        } else {
            db.collection("RestaurantProfile").whereField("userID",
                                                          isEqualTo: restaurantID ?? "NA")
                .addSnapshotListener { (querySnapshot, error) in
                    
                    if let e = error {
                        print("There was an issue retrieving data from Firestore. \(e)")
                    } else {
                        for document in querySnapshot!.documents{
                            let data = document.data()
                            location = data["restaurantLocation"] as? String ?? "NA"
                        }
                        self.db.collection("RestaurantProfile").document(self.restaurantID ?? "NA").collection("Reservations").document(self.userNameLabel.text!).setData([
                            "name": self.userNameLabel.text!,
                            "date": self.UserChoseDate,
                            "email": self.userEmailLabel.text!,
                            "number of seats": self.UserChoseSeatsNumber,
                            "seat": self.UserChoseIndoors,
                            "section": self.UserChoseWithFamily,
                        ], merge: true) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                                self.db.collection("UserProfile").document(user.uid).collection("Reservations").document(self.restaurantName!).setData([
                                    "name": self.restaurantName!,
                                    "date": self.UserChoseDate,
                                    "email": self.userEmailLabel.text!,
                                    "number of seats": self.UserChoseSeatsNumber,
                                    "seat": self.UserChoseIndoors,
                                    "section": self.UserChoseWithFamily,
                                    "restLocation": location
                                ], merge: true) { err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                    } else {
                                        print("Document successfully written!")
                                        DispatchQueue.main.async {
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }
    
  
    private func isRestaurant(completion: @escaping (String) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        db.collection("RestaurantProfile").whereField("userID", isEqualTo: user.uid)
            .addSnapshotListener { (querySnapshot, error) in
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    for document in querySnapshot!.documents{
                        let data = document.data()
                        completion(data["isRest"] as? String ?? "no")
                    }
                    
                }
            }
    }
}

//MARK: - UIPickerView

extension AddReservationVC: UIPickerViewDelegate,
                            UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
  
  
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
  
  
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return "\(row + 1) seats"
    }
  
  
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        print("row \(row + 1)")
        UserChoseSeatsNumber = "\(row + 1)"
    }
}
