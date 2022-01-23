//
//  RestaurantDetailVC.swift
//  SmartTable.
//
//  Created by macbook air on 09/06/1443 AH.
//

import UIKit
import Firebase
class RestaurantDetailVC: UIViewController {
  
  //MARK: - Properties
  
  var restImageURL: String?
  var restTitle: String?
  var restDescription: String?
  var restaurantID: String?
  var restaurantLocation: String?
  
  private let storage = Storage.storage()
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  
  private let restImageView: UIImageView =  {
    let image = UIImageView()
    image.contentMode = .scaleToFill
    image.clipsToBounds = true
    image.image = UIImage(systemName: "house.fill")?.withTintColor(.systemGray6).withRenderingMode(.alwaysOriginal)
    return image
  }()
  
  private let restTitleLabel: UILabel = {
    let title = UILabel()
    title.textColor =  .label
    title.numberOfLines = 0
    title.textAlignment = .left
    title.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 25, weight: .bold))
    return title
  }()
  
  private let restBodyLabel: UILabel = {
    let description = UILabel()
    description.textColor =  .label
    description.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 16, weight: .regular))
    description.numberOfLines = 0
    description.textAlignment = .left
    
    return description
  }()
  
  let reserveTableButton: UIButton = {
    let button = UIButton(type: .system)
    button.setupButton(with: "Reserve a table")
    return button
  }()
  
  //MARK: - View Controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    restTitleLabel.text = restTitle
    restBodyLabel.text = restDescription
    self.navigationItem.largeTitleDisplayMode = .never
    title = restTitle
    setupScrollView()
    setupView()
    readImageFromFirestore(with: restImageURL ?? "NA") { image in
      DispatchQueue.main.async {
        self.restImageView.image = image
        
        
      }
    }
    view.backgroundColor = UIColor(named: "Secondary Brand Fill Color")
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                    height: UIScreen.main.bounds.height+20)
    
  }
  
  //MARK: - Methode
  
  private func setupView() {
    restImageView.translatesAutoresizingMaskIntoConstraints = false
    restTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    restBodyLabel.translatesAutoresizingMaskIntoConstraints = false
    reserveTableButton.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(restImageView)
    scrollView.addSubview(reserveTableButton)
    contentView.addSubview(restTitleLabel)
    contentView.addSubview(restBodyLabel)
    
    reserveTableButton.addTarget(self,
                                 action: #selector(reserveTableButtonPressed),
                                 for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      
      
      restImageView.topAnchor
        .constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
      restImageView.leadingAnchor
        .constraint(equalTo: contentView.leadingAnchor),
      restImageView.trailingAnchor
        .constraint(equalTo: contentView.trailingAnchor),
      restImageView.heightAnchor
        .constraint(equalToConstant: view.frame.size.height / 3.65),
      
      reserveTableButton.topAnchor
        .constraint(equalTo: restImageView.bottomAnchor, constant: 28),
      reserveTableButton.leadingAnchor
        .constraint(equalTo: contentView.leadingAnchor, constant: 20),
      reserveTableButton.heightAnchor
        .constraint(equalToConstant: 35),
      reserveTableButton.widthAnchor
        .constraint(equalToConstant: 135),
      
      restTitleLabel.topAnchor
        .constraint(equalTo: reserveTableButton.bottomAnchor, constant: 15),
      restTitleLabel.leadingAnchor
        .constraint(equalTo: contentView.leadingAnchor, constant: 20),
      restTitleLabel.trailingAnchor
        .constraint(equalTo: contentView.trailingAnchor, constant: -20),
      
      restBodyLabel.topAnchor
        .constraint(equalTo: restTitleLabel.bottomAnchor, constant: 13),
      restBodyLabel.leftAnchor
        .constraint(equalTo: contentView.leftAnchor, constant: 20),
      restBodyLabel.rightAnchor
        .constraint(equalTo: contentView.rightAnchor, constant: -20)
    ])
  }
  
  
  @objc func reserveTableButtonPressed() {
    print("Pressed")
    let sheetViewController = AddReservationVC(nibName: nil,
                                               bundle: nil)
    sheetViewController.restaurantID = restaurantID ?? "NA"
    sheetViewController.restaurantName = restTitle
    self.present(sheetViewController, animated: true,
                 completion: nil)
  }
  
  //MARK: - Methode
  
  private func readImageFromFirestore(with url: String,
                                      completion: @escaping (UIImage) -> ()) {
    if  url != "NA"
    {
      let httpsReference = self.storage.reference(forURL: url)
      
      
      httpsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
        if let error = error {
          print("ERROR GETTING DATA \(error.localizedDescription)")
        } else {
          completion(UIImage(data: data!) ?? UIImage())
          
        }
      }
      
    }
  }
  
  //MARK: - Functions
  
  func setupScrollView(){
    scrollView.isScrollEnabled = true
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    
    scrollView.centerXAnchor
      .constraint(equalTo: view.centerXAnchor).isActive = true
    scrollView.widthAnchor
      .constraint(equalTo: view.widthAnchor).isActive = true
    scrollView.topAnchor
      .constraint(equalTo: view.topAnchor).isActive = true
    scrollView.bottomAnchor
      .constraint(equalTo: view.bottomAnchor).isActive = true
    
    contentView.centerXAnchor
      .constraint(equalTo: scrollView.centerXAnchor).isActive = true
    contentView.widthAnchor
      .constraint(equalTo: scrollView.widthAnchor).isActive = true
    contentView.topAnchor
      .constraint(equalTo: scrollView.topAnchor).isActive = true
    contentView.bottomAnchor
      .constraint(equalTo: scrollView.bottomAnchor).isActive = true
  }
}
