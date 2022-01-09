//
//  HomeVC.swift
//  SmartTabel
//
//  Created by macbook air on 09/05/1443 AH.
//




import UIKit
import Firebase

class HomeVC: UIViewController {
    
    private let db = Firestore.firestore()
  
  
  @IBOutlet weak var tableView: UITableView!
  
    private let searchBar = UISearchController()
    private var restaurants : [Restaurent]              = []
    private var filteredResults: [Restaurent]           = []
//  private let tableView                               = UITableView(frame: .zero, style: .insetGrouped)
    //private var imagesArr                               = [UIImage]()
    private let storage                                 = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .stBackground
        title = "Home"
        uiSettengs()
        getData()
      
        
//        let profile = UIBarButtonItem(title: "Profile", style: .done, target: self, action: #selector(goToRestProfile))
//        profile.tintColor = UIColor(#colorLiteral(red: 0, green: 0.8117647059, blue: 0.9921568627, alpha: 1))
//
//        navigationItem.rightBarButtonItem = profile
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isUserIsSignedIn() {
            showWelcomeScreen()
        }else{
            
        }
        
    }
    
    
    private func isUserIsSignedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    
    private func showWelcomeScreen() {
        let vc = UINavigationController(rootViewController: WelcomeVC())
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
//    @objc private func goToRestProfile() {
//        self.navigationController?.pushViewController(RestaurentProfile(), animated: true)
//    }
    
    func uiSettengs(){
//        tableView.backgroundColor = .stBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RestCell.self, forCellReuseIdentifier: RestCell.id)
//        tableView.rowHeight                                                     = UITableView.automaticDimension
//        tableView.estimatedRowHeight                                            = 400
        tableView.delegate = self
        tableView.dataSource = self
//        view.addSubview(tableView)
        
       
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
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
                        self.restaurants.append(Restaurent(restName: data["name"] as? String ?? "NA", restEmail: data["email"] as? String ?? "NA", restImageURL: data["userImageURL"] as? String ?? "NA"))
                        
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
            }
    }
    
  
    private func readImageFromFirestore(with url: String, completion: @escaping (UIImage) -> ()){
        
        
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

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.isActive && !searchBar.searchBar.text!.isEmpty {
            return filteredResults.count
        }else{
            return restaurants.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestCell.id, for: indexPath) as! RestCell
        
        
        if searchBar.isActive && !searchBar.searchBar.text!.isEmpty {
            //cell.stroeName.text = filteredResults[indexPath.row].restName
            //cell.storeEmail.text = filteredResults[indexPath.row].restEmail
            
            return cell
        }else{
            
            //cell.stroeName.text = restaurants[indexPath.row].restName
            //cell.storeEmail.text = restaurants[indexPath.row].restEmail
            //cell.storeImage.image = UIImage(systemName: "house.fill")?.withTintColor(.black).withRenderingMode(.alwaysOriginal)
            
            readImageFromFirestore(with: restaurants[indexPath.row].restImageURL ?? "NA") { image in
                DispatchQueue.main.async {
                    //cell.storeImage.image = image
                }
            }
            
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
          print("\n\n!searchController.isActive\n\n")
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
        }else{
            tableView.reloadData()
        }
    }
}
