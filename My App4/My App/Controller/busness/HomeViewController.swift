//
//  HomeViewController.swift
//  My App
//
//  Created by macbook air on 09/05/1443 AH.
//

import UIKit

class HomeViewController: UIViewController {
  
  @IBOutlet weak var listOfBusiness: UITableView!
  
  var listArray = ["The Two",
                   "Lobani",
                   "Out Side",
                   "Banan Louge"
  ]
  
    override func viewDidLoad() {
        super.viewDidLoad()

      
      listOfBusiness.dataSource = self
      listOfBusiness.delegate = self
      
    }
    
  

}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listArray.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfResturanttt", for: indexPath) as! BusinessOflistRestaurantTableViewCell
    cell.nameLable?.text = listArray[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 221
  }
}
