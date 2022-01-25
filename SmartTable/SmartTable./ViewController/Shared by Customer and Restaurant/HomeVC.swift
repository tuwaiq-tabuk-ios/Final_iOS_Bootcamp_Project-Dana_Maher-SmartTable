//
//  HomeVC.swift
//  SmartTabel
//
//  Created by macbook air on 09/05/1443 AH.
//




import UIKit
import Firebase
import CoreLocation

class HomeVC: UIViewController {
  
  //MARK: - Properties
  
  private let db = Firestore.firestore()
  private let searchBar = UISearchController()
  
  private var restaurants : [Restaurent] = []
  private var filteredResults: [Restaurent] = []
  
  private let storage = Storage.storage()
  
  private var isRest = false
  var locationManager = CLLocationManager()
  
  
  let profileButton: UIButton = {
    let button = UIButton(type: .system)
    button.circularButton()
    button.addTarget(self,
                     action: #selector(goToRestProfile),
                     for: .touchUpInside)
    button.isHidden = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let profileButtonForUser: UIButton = {
    let button = UIButton(type: .system)
    button.circularButton()
    button.addTarget(self,
                     action: #selector(goToUserProfile),
                     for: .touchUpInside)
    button.isHidden = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  // MAKR: - IBOutlet
  
  @IBOutlet weak var tableView: UITableView!
  
  //MARK: - View Controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Home"
    
    uiSettengs()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if !isUserIsSignedIn() {
      showWelcomeScreen()
    } else {
      getData()
      //هنا كود الاشعار اذا كان مطعم مايقدر يدخل يشوف تفاصيل المطاعم واذا كان مستخدم يقدر يشوف تفاصيل المطاعم
      isRestaurant { isRest in
        if isRest == "yes" {
          DispatchQueue.main.async {
            self.profileButton.isHidden = false
            self.isRest = true
            self.profileButtonForUser.isHidden = true
            
          }
          self.setupLocation()
          self.locationManager.startUpdatingLocation()
        } else if isRest == "no"{
          DispatchQueue.main.async {
            self.profileButton.isHidden = true
            self.isRest = false
            self.profileButtonForUser.isHidden = false
          }
        }
      }
    }
  }
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  //MARK: - Methode
  
  private func setupLocation() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    switch locationManager.authorizationStatus {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .denied:
      locationManager.requestWhenInUseAuthorization()
    default:
      break
    }
  }
  
  
  private func isUserIsSignedIn() -> Bool {
    return Auth.auth().currentUser != nil
  }
  
  
  private func showWelcomeScreen() {
    let vc = UINavigationController(rootViewController: WelcomeVC())
    vc.modalTransitionStyle = .flipHorizontal
    vc.modalPresentationStyle = .fullScreen
    self.present(vc,
                 animated: true,
                 completion: nil)
  }
  
  // go to restaurantprofile
  
  @objc private func goToRestProfile() {
    self.navigationController?.pushViewController(RestaurentProfile(),
                                                  animated: true)
    
  }
  
  // go to usreProfile
  
  @objc private func goToUserProfile() {
    self.navigationController?.pushViewController(UserProfile(),
                                                  animated: true)
    
  }
  
  //MARK: - Methode
  
  //  Read from document in firebase
  
  private func isRestaurant(completion: @escaping (String) -> ()){
    guard let user = Auth.auth().currentUser else {
      return
    }
    db.collection("RestaurantProfile").whereField("userID",
                                                  isEqualTo: user.uid)
      .addSnapshotListener { (querySnapshot, error) in
        
        if let e = error {
          print("There was an issue retrieving data from Firestore. \(e)")
        } else {
          
          if querySnapshot!.documents.isEmpty {
            completion("no")
          } else {
            for document in querySnapshot!.documents{
              let data = document.data()
              completion(data["isRest"] as? String ?? "no")
            }
          }
        }
      }
  }
  
  //MARK: - Functions
  
  func uiSettengs() {
    tableView.register(RestCell.self,
                       forCellReuseIdentifier: RestCell.id)
    
    searchBar.loadViewIfNeeded()
    searchBar.searchResultsUpdater = self
    searchBar.obscuresBackgroundDuringPresentation = false
    searchBar.searchBar.returnKeyType = .done
    searchBar.searchBar.sizeToFit()
    searchBar.searchBar.placeholder = "Search for a restaurent"
    searchBar.hidesNavigationBarDuringPresentation = false
    definesPresentationContext = true
    
    navigationItem.searchController = searchBar
    navigationItem.hidesSearchBarWhenScrolling = true
    searchBar.searchBar.delegate = self
    
    view.addSubview(profileButton)
    view.addSubview(profileButtonForUser)
    
    profileButton.bottomAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    profileButton.trailingAnchor
      .constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    profileButton.widthAnchor
      .constraint(equalToConstant: 45).isActive = true
    profileButton.heightAnchor
      .constraint(equalToConstant: 45).isActive = true
    
    profileButtonForUser.bottomAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    profileButtonForUser.trailingAnchor
      .constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    profileButtonForUser.widthAnchor
      .constraint(equalToConstant: 45).isActive = true
    profileButtonForUser.heightAnchor
      .constraint(equalToConstant: 45).isActive = true
  }
  
  
  func getData(){
    db.collection("RestaurantProfile")
      .addSnapshotListener { (querySnapshot, error) in
        
        if let e = error {
          print("There was an issue retrieving data from Firestore. \(e)")
        } else {
          self.restaurants = []
          for document in querySnapshot!.documents{
            let data = document.data()
            self.restaurants.append(Restaurent(restName: data["name"] as? String ?? "NA",
                                               restDescription: data["restaurantDescription"] as? String ?? "NA",
                                               restImageURL: data["userImageURL"] as? String ?? "NA",
                                               id: data["userID"] as? String ?? "NA"))
          }
          DispatchQueue.main.async {
            self.tableView.reloadData()
            
          }
          
        }
      }
  }
  
  //MARK: - Get Image
  
  private func readImageFromFirestore(with url: String,
                                      completion: @escaping (UIImage) -> ()) {
    
    
    if  url != "NA"
    {
      
      let httpsReference = self.storage.reference(forURL: url)
      
      
      httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
        if let error = error {
          // Uh-oh, an error occurred!
          print("ERROR GETTING DATA \(error.localizedDescription)")
        } else {
          // Data for "images/island.jpg" is returned
          
          completion(UIImage(data: data!) ?? UIImage())
        }
      }
      
    }
  }
}

//MARK: - UITableView

extension HomeVC: UITableViewDelegate,
                  UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    if searchBar.isActive && !searchBar.searchBar.text!.isEmpty {
      return filteredResults.count
    } else {
      return restaurants.count
    }
  }
  
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RestCell.id,
                                             for: indexPath) as! RestCell
    
    
    
    if searchBar.isActive && !searchBar.searchBar.text!.isEmpty {
      cell.restName.text = filteredResults[indexPath.row].restName
      cell.restEmail.text = filteredResults[indexPath.row].restDescription
      
      return cell
    } else {
      
      cell.restName.text = restaurants[indexPath.row].restName
      cell.restEmail.text = restaurants[indexPath.row].restDescription
      cell.restImage.image = UIImage(systemName: "house.fill")?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
      
      readImageFromFirestore(with: restaurants[indexPath.row].restImageURL ?? "NA") { image in
        DispatchQueue.main.async {
          cell.restImage.image = image
        }
      }
      return cell
    }
  }
  
  
  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath,
                          animated: true)
    
    if isRest {
      let alert = UIAlertController(title: "Sorry",
                                    message: "Please, Log in as a customer to reserve a table.",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK",
                                    style: .cancel,
                                    handler: nil))
      self.present(alert,
                   animated: true)
      
    } else {
      
      let vc = RestaurantDetailVC()
      vc.restImageURL = self.restaurants[indexPath.row].restImageURL
      vc.restDescription = self.restaurants[indexPath.row].restDescription
      vc.restTitle = self.restaurants[indexPath.row].restName
      vc.restaurantID = self.restaurants[indexPath.row].id
      self.navigationController?.pushViewController(vc,
                                                    animated: true)
    }
  }
}

//MARK: - UISearch

extension HomeVC: UISearchResultsUpdating,
                  UISearchBarDelegate {
  func updateSearchResults(for searchController: UISearchController) {
    if !searchController.isActive {
      return
    }
    
    let searchBar = searchBar.searchBar
    
    if let userEnteredSearchText = searchBar.text {
      findResultsBasedOnSearch(with: userEnteredSearchText)
    }
  }
  
  
  private func findResultsBasedOnSearch(with text: String)  {
    filteredResults.removeAll()
    if !text.isEmpty {
      filteredResults = restaurants.filter{ item in
        item.restName.lowercased().contains(text.lowercased())
      }
      tableView.reloadData()
    } else {
      tableView.reloadData()
    }
  }
}

//MARK: - CLLocationManager

extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        
        print("this is the location \(location.coordinate.latitude), long \(location.coordinate.longitude)")
        saveLocationMessage(location: location)
        locationManager.stopUpdatingLocation()
    }
    
    
    
    private func saveLocationMessage(location: CLLocation) {
       guard let userId = Auth.auth().currentUser?.uid else {return}
        
        db.collection("RestaurantProfile").document(userId).setData([
            "restaurantLocation": "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
}
