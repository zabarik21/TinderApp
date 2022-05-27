//
//  MainTabBarController.swift
//  TinderApp
//
//  Created by Timofey on 27/5/22.
//

import UIKit


class MainTabBarController: UITabBarController {
    
    lazy var peopleVC = PeopleViewController()
    lazy var messagesVC = MessagerViewController()
    lazy var profileVC = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        self.view.backgroundColor = .black
    }
    
    
    /// TO-DO: complete floating tabbar setup 
    private func setupTabBar() {
        let regularConfiguration = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        let peopleTabBarImage = UIImage(systemName: "figure.wave", withConfiguration: regularConfiguration)!
        let messagesTabBarImage = UIImage(systemName: "message", withConfiguration: regularConfiguration)!
        let profileTabBarImage = UIImage(systemName: "person", withConfiguration: regularConfiguration)!
        
        setupVCTabBar(viewController: peopleVC, title: "Discover", image: peopleTabBarImage)
        setupVCTabBar(viewController: messagesVC, title: "Messages", image: messagesTabBarImage)
        setupVCTabBar(viewController: profileVC, title: "Profile", image: profileTabBarImage)
        
        viewControllers = [
            peopleVC,
            messagesVC,
            profileVC
        ]
    }
    
    private func setupVCTabBar(viewController: UIViewController, title: String, image: UIImage) {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
    }
    
}
