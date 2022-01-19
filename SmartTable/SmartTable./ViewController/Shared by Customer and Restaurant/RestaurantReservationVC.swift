//
//  RestaurantReservationVC.swift
//  SmartTabel
//
//  Created by macbook air on 09/06/1443 AH.
//

import UIKit
import Firebase
import CoreLocation
import MapKit
class RestaurantReservationVC: UIViewController {
  
  //MARK: - Properties

    private let db = Firestore.firestore()
    private let searchBar = UISearchController()
  
    private var reservations : [Reservations] = []
    private var filteredResults: [Reservations] = []
  
  //MAKR: - IBOutlet

  @IBOutlet weak var tableView: UITableView!
  
  //MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        uiSettengs()
        getData()
      
      tableView.delegate = self
      tableView.dataSource = self
    }
    
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
  //MARK: - Functions

    func uiSettengs() {
        tableView.register(ResCell.self, forCellReuseIdentifier: ResCell.id)
     
        
        
        searchBar.loadViewIfNeeded()
        searchBar.searchResultsUpdater = self
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.returnKeyType = .done
        searchBar.searchBar.sizeToFit()
        searchBar.searchBar.placeholder = "Search for a customer"
        searchBar.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = true
        searchBar.searchBar.delegate = self
    }
    
  //MARK: - Methode

    private func isRestaurant(completion: @escaping (String) -> ()){
        guard let user = Auth.auth().currentUser else {return}
        db.collection("RestaurantProfile").whereField("userID", isEqualTo: user.uid)
            .addSnapshotListener { (querySnapshot, error) in
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                   
                    if querySnapshot!.documents.isEmpty {
                        completion("no")
                    }else{
                        for document in querySnapshot!.documents{
                            let data = document.data()
                            completion(data["isRest"] as? String ?? "no")
                        }
                    }
                }
            }
    }
  
  //MARK: - Functions

    func getData(){
        guard let user = Auth.auth().currentUser else {return}
        
        isRestaurant { isRest in
            if isRest == "yes" {
                self.db.collection("RestaurantProfile").document(user.uid).collection("Reservations")
                    .addSnapshotListener { (querySnapshot, error) in
                        
                        if let e = error {
                            print("There was an issue retrieving data from Firestore. \(e)")
                        } else {
                            self.reservations = []
                            for document in querySnapshot!.documents{
                                let data = document.data()
                                self.reservations.append(Reservations(date: data["date"] as? String ?? "NA" ,  email: data["email"] as? String ?? "NA", name: data["name"] as? String ?? "NA", numberOfSeats: data["number of seats"] as? String ?? "NA", seat: data["seat"] as? String ?? "NA", section: data["section"] as? String ?? "NA", location: data["restaurantDescription"] as? String ?? "NA"))
                                
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                            }
                            
                        }
                    }
            } else if isRest == "no" {
               
                self.db.collection("UserProfile").document(user.uid).collection("Reservations")
                    .addSnapshotListener { (querySnapshot, error) in
                        
                        if let e = error {
                            print("There was an issue retrieving data from Firestore. \(e)")
                        } else {
                            self.reservations = []
                            for document in querySnapshot!.documents{
                                let data = document.data()
                                self.reservations.append(Reservations(date: data["date"] as? String ?? "NA" ,  email: data["email"] as? String ?? "NA", name: data["name"] as? String ?? "NA", numberOfSeats: data["number of seats"] as? String ?? "NA", seat: data["seat"] as? String ?? "NA", section: data["section"] as? String ?? "NA", location: data["restLocation"] as? String ?? "NA"))
                               
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                            }
                            
                        }
                    }
            }
        }
    }
}

//MARK: - UITableView

extension RestaurantReservationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.isActive && !searchBar.searchBar.text!.isEmpty {
            return filteredResults.count
        }else{
            return reservations.count
        }
    }
  
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResCell.id, for: indexPath) as! ResCell
        
        
        
        if searchBar.isActive && !searchBar.searchBar.text!.isEmpty {
            
            
            cell.dateLbl.text = filteredResults[indexPath.row].date
            cell.nameLbl.text = filteredResults[indexPath.row].name
            cell.emailLbl.text = filteredResults[indexPath.row].email
            cell.nosLbl.text = "number of seats: " + filteredResults[indexPath.row].numberOfSeats
            cell.sectionLbl.text = "section: " +  filteredResults[indexPath.row].section
            cell.seatLbl.text = "seat: " + filteredResults[indexPath.row].seat
            
            return cell
        } else {
            cell.dateLbl.text = reservations[indexPath.row].date
            cell.nameLbl.text = reservations[indexPath.row].name
            cell.emailLbl.text = reservations[indexPath.row].email
            cell.nosLbl.text = "number of seats: " +  reservations[indexPath.row].numberOfSeats
            cell.sectionLbl.text = "section: " +  reservations[indexPath.row].section
            cell.seatLbl.text = "seat: " + reservations[indexPath.row].seat
            return cell
        }
    }
  
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        isRestaurant { isRest in
            if isRest == "no" {
                let location = self.reservations[indexPath.row].location
                let message = location.components(separatedBy: ",")
                print(message)
                guard let lat = Double(message[0]) else { return }
                guard let lon = Double(message[1]) else { return }
                
                let userCoordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
                let regionDistance:CLLocationDistance = 200
                let regionSpan = MKCoordinateRegion(center: userCoordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                ]
                let placemark = MKPlacemark(coordinate: userCoordinates, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = "Enjoy your meal!"
                mapItem.openInMaps(launchOptions: options)
            }
        }
        
    }
}

//MARK: - UISearch

extension RestaurantReservationVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
            return
        }
        let searchBar = searchBar.searchBar
        
        if let userEnteredSearchText = searchBar.text {
            findResultsBasedOnSearch(with: userEnteredSearchText)
        }
    }
  
  //MARK: - Methode

    private func findResultsBasedOnSearch(with text: String)  {
        filteredResults.removeAll()
        if !text.isEmpty {
            filteredResults = reservations.filter{ item in
                item.name.lowercased().contains(text.lowercased())
            }
            tableView.reloadData()
        } else {
            tableView.reloadData()
        }
    }
}
