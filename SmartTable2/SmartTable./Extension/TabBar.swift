//
//  TabBar.swift
//  SmartTabel
//
//  Created by macbook air on 09/05/1443 AH.
//

import UIKit

class DashboardTabBarController: UITabBarController {

   
    
    override func viewDidLoad() {
        super.viewDidLoad()


                    self.viewControllers = [


                        
//                        barItem(tabBarTitle: "Restaurants", tabBarImage: UIImage(systemName: "house.fill")!.withTintColor(UIColor.black, renderingMode: .alwaysOriginal), viewController: HomeForRestaurantVC()),
                        barItem(tabBarTitle: "Reservations", tabBarImage: UIImage(systemName: "rectangle.dashed.and.paperclip")!.withTintColor(UIColor.black, renderingMode: .alwaysOriginal), viewController:  RestaurantReservationVC()),
                       
                        
                        


                    ]
              
        
        
        
        
        
        selectedIndex = 0
        tabBar.isTranslucent = true
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(#colorLiteral(red: 0, green: 0.8117647059, blue: 0.9921568627, alpha: 1))], for: .selected)
        tabBar.unselectedItemTintColor = .gray
    }


    private func barItem(tabBarTitle: String, tabBarImage: UIImage, viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = tabBarTitle
        navigationController.tabBarItem.image = tabBarImage
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
    

   
}
