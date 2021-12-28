//
//  HomePersonViewController.swift
//  My App
//
//  Created by macbook air on 09/05/1443 AH.
//

import UIKit


class HomePersonViewController :UIViewController {
  
  @IBOutlet weak var listsTableView: UITableView!
  
  
  var listArray: Spots!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    listArray = Spots()
    listsTableView.dataSource = self
    listsTableView.delegate = self
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    listArray.loadData {
      self.listsTableView.reloadData()
    }
  }
  
}


extension HomePersonViewController: UITableViewDataSource, UITableViewDelegate {
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listArray.spotArray.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListOfResturantt", for: indexPath) as! RestaurantTableViewCell
    cell.nameLable?.text = listArray.spotArray[indexPath.row].name
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 221
  }
  
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let todo = listArray[indexPath.row]
//    let vc = storyboard?.instantiateViewController(withIdentifier: "detailsVC") as? DetailsOfPersonViewController
//
//    if let view = vc{
//      navigationController?.pushViewController(view, animated: true)
//    }
    
  
  
  
}
