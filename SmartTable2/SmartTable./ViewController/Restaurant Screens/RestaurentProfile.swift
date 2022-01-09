//
//  RestaurentProfile.swift
//  SmartTabel
//
//  Created by Faisal on 04/01/2022.
//
//
//
import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class RestaurentProfile: UIViewController {
    let db = Firestore.firestore()
    let imagePicker = UIImagePickerController()
    let storage = Storage.storage()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 13
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        return view
    }()
    
    let profileImage: UIImageView = {
        let pI = UIImageView()
        pI.contentMode = .scaleAspectFit
        pI.clipsToBounds = true
        pI.layer.cornerRadius = 80
        pI.layer.borderColor = UIColor.stBackground!.cgColor
        pI.layer.borderWidth = 1
        pI.image = UIImage(systemName: "house.fill")
        return pI
    }()
    
    let userNameLabel: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 29, weight: .bold)
        name.textColor = .black
        name.textAlignment = .center
        
        return name
    }()
    
    let addDescriptionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setupButton(with: "add Description")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let userDescriptionLabel: UILabel = {
        let userDescription = UILabel()
        userDescription.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        userDescription.textAlignment = .left
        userDescription.textColor = .black
        userDescription.numberOfLines = 0
        userDescription.lineBreakMode = .byWordWrapping
        return userDescription
    }()
    
    let signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setupButton(with: "Sign out")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .stBackground
        title = "Restaurent Profile"
      
        readImageFromFirestore()
        setUpLabels()
      self.dismissKeyboard()
      overrideUserInterfaceStyle = .light
          navigationItem.setHidesBackButton(true, animated: true)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCurrentUsers()
    }
    
    
    
    
    
    func setUpLabels() {
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive                                = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive                                = true
        containerView.widthAnchor.constraint(equalToConstant: 325).isActive                                         = true
        containerView.heightAnchor.constraint(equalToConstant: 405).isActive                                        = true
        

        
        
        profileImage.tintColor  = .stBackground
        profileImage.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImage.addGestureRecognizer(tapRecognizer)
        
        containerView.addSubview(profileImage)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 160).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 160).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20).isActive = true
        userNameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        
        
        containerView.addSubview(signOutButton)
        
        
        userDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(userDescriptionLabel)
        userDescriptionLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 3).isActive = true
        userDescriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        userDescriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        
        containerView.addSubview(signOutButton)
        
        signOutButton.topAnchor.constraint(equalTo: userDescriptionLabel.bottomAnchor, constant: 20).isActive = true
        signOutButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        signOutButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        
        containerView.addSubview(addDescriptionButton)
        addDescriptionButton.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: 5).isActive = true
        addDescriptionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        addDescriptionButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        addDescriptionButton.widthAnchor.constraint(equalToConstant: 145).isActive = true

        addDescriptionButton.addTarget(self, action: #selector(addDescriptionButtonTapped), for: .touchUpInside)
    }
    
    @objc func signOutButtonTapped() {
        do{
            try Auth.auth().signOut()
//            self.navigationController?.popToRootViewController(animated: true)
          self.transitionToHome()
        }catch{print("Error")}
        
        
    }

    @objc func addDescriptionButtonTapped() {
        let sheetViewController = AddDescriptionVC(nibName: nil, bundle: nil)
        self.present(sheetViewController, animated: true, completion: nil)
    }
    
    func setupImagePicker() {
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    @objc func imageTapped() {
        print("Image tapped")
        setupImagePicker()
    }
    
    func saveImageToFirestore(url: String, userId: String) {
        
        db.collection("RestaurantProfile").document(userId).setData([
            "userImageURL": url,
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    private func readImageFromFirestore(){
        guard let currentUser = Auth.auth().currentUser else {return}
        
        db.collection("RestaurantProfile").whereField("userID", isEqualTo: currentUser.uid)
            .addSnapshotListener { (querySnapshot, error) in
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            
                            if let imageURL = data["userImageURL"] as? String
                            {
                                
                                let httpsReference = self.storage.reference(forURL: imageURL)
                                
                                
                                httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                                    if let error = error {
                                        // Uh-oh, an error occurred!
                                        print("ERROR GETTING DATA \(error.localizedDescription)")
                                    } else {
                                        // Data for "images/island.jpg" is returned
                                        
                                        DispatchQueue.main.async {
                                            self.profileImage.image = UIImage(data: data!)
                                        }
                                        
                                    }
                                }
                                
                            } else {
                                
                                print("error converting data")
                                DispatchQueue.main.async {
                                    self.profileImage.image = UIImage(systemName: "house.fill")
                                }
                                
                            }
                            
                            
                        }
                    }
                }
            }
    }
    
    private func fetchCurrentUsers() {
        guard let currentUser = FirebaseAuth.Auth.auth().currentUser else {return}
        db.collection("RestaurantProfile").whereField("userID", isEqualTo: currentUser.uid)
            .addSnapshotListener { (querySnapshot, error) in
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        print(snapshotDocuments)
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let userName = data["name"] as? String,
                                let userEmail = data["restaurantDescription"] as? String
                            {
                                DispatchQueue.main.async {
                                    self.userNameLabel.text = userName
                                    self.userDescriptionLabel.text = userEmail
                                }
                                
                                
                            }
                        }
                    }
                }
                
            }
    }
  
  func transitionToHome() {
    
    
    let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController2) as! UINavigationController
    
    view.window?.rootViewController = homeViewController
    view.window?.makeKeyAndVisible()
    
    present(homeViewController, animated: true, completion: nil)
    
  }
    
}



extension RestaurentProfile: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        guard let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        guard let d: Data = userPickedImage.jpegData(compressionQuality: 0.5) else { return }
        guard let currentUser = Auth.auth().currentUser else {return}
        
        
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        let ref = storage.reference().child("RestaurentProfileImages/\(currentUser.email!)/\(currentUser.uid).jpg")
        
        ref.putData(d, metadata: metadata) { (metadata, error) in
            if error == nil {
                ref.downloadURL(completion: { (url, error) in
                    self.saveImageToFirestore(url: "\(url!)", userId: currentUser.uid)
                    
                })
            }else{
                print("error \(String(describing: error))")
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
}


