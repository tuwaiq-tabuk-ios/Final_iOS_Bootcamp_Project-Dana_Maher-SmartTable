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
    
  
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userDescriptionLabel: UILabel!
  @IBOutlet weak var addDescriptionButton: UIButton!
  @IBOutlet weak var signOutButton: UIButton!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        readImageFromFirestore()
        setUpLabels()
      self.dismissKeyboard()
      overrideUserInterfaceStyle = .light
    }
  
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCurrentUsers()
    }
   
  
  @IBAction func signOutButtonTapped(_ sender: UIButton) {
        do {
              try Auth.auth().signOut()
          if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC") as? UINavigationController {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
              }
            } catch{
              print("ERROR")
            }
  }


    func setUpLabels() {
        

        profileImage.tintColor  = .stBackground
        profileImage.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImage.addGestureRecognizer(tapRecognizer)
        
        signOutButton.addTarget(self,
                                action: #selector(signOutButtonTapped),
                                for: .touchUpInside)

        addDescriptionButton.addTarget(self,
                                       action: #selector(addDescriptionButtonTapped),
                                       for: .touchUpInside)
    }
  
  
//  @objc func signOutButtonTapped() {
//
//
//    do {
//          try Auth.auth().signOut()
//          if let vc = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController2) as! UINavigationController {
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
//          }
//        } catch{
//          print("ERROR")
//        }
//      do{
//          try Auth.auth().signOut()
////          self.navigationController?.popToRootViewController(animated: true)
//        self.transitionToHome()
//      }catch{print("Error")}
//
//
  
  
    @objc func addDescriptionButtonTapped() {
        let sheetViewController = AddDescriptionVC(nibName: nil,
                                                   bundle: nil)
        self.present(sheetViewController,
                     animated: true,
                     completion: nil)
    }
    
  
    func setupImagePicker() {
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker,
                animated: true)
    }
  
  
    @objc func imageTapped() {
        print("Image tapped")
        setupImagePicker()
    }
    
  
    func saveImageToFirestore(url: String,
                              userId: String) {
        
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
        guard let currentUser = Auth.auth().currentUser else { return }
        
        db.collection("RestaurantProfile").whereField("userID",
                                                      isEqualTo: currentUser.uid)
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
        guard let currentUser = FirebaseAuth.Auth.auth().currentUser else { return }
        db.collection("RestaurantProfile").whereField("userID",
                                                      isEqualTo: currentUser.uid)
            .addSnapshotListener { (querySnapshot,
                                    error) in
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
    
    present(homeViewController, animated: true,
            completion: nil)
    
  }
    
}


extension RestaurentProfile: UIImagePickerControllerDelegate,
                             UINavigationControllerDelegate{
    
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let d: Data = userPickedImage.jpegData(compressionQuality: 0.5) else { return }
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        let ref = storage.reference().child("RestaurentProfileImages/\(currentUser.email!)/\(currentUser.uid).jpg")
        
        ref.putData(d,
                    metadata: metadata) { (metadata,
                                           error) in
            if error == nil {
                ref.downloadURL(completion: { (url,
                                               error) in
                    self.saveImageToFirestore(url: "\(url!)",
                                              userId: currentUser.uid)
                })
            } else {
                print("error \(String(describing: error))")
            }
        }
        picker.dismiss(animated: true,
                       completion: nil)
    }
}


