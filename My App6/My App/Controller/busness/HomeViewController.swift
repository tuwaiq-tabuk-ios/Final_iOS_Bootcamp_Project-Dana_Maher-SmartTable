//
//  HomeViewController.swift
//  My App
//
//  Created by macbook air on 09/05/1443 AH.
//

import UIKit

class HomeViewController: UIViewController {
  
  @IBOutlet weak var listOfBusiness: UITableView!
  
  var listArray: Spots!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      listArray = Spots()
      listOfBusiness.dataSource = self
      listOfBusiness.delegate = self
      
    }
    
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    listArray.loadData {
      self.listOfBusiness.reloadData()
    }
  }

}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listArray.spotArray.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfResturanttt", for: indexPath) as! BusinessOflistRestaurantTableViewCell
    cell.nameLable?.text = listArray.spotArray[indexPath.row].name
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 221
  }
}
