//
//  MainTabBarController.swift
//  TinderApp
//
//  Created by Timofey on 27/5/22.
//

import UIKit


enum Constants  {
    static let ovalHeight: Int = 313
}

class MainTabBarController: UITabBarController {
    
    lazy var peopleVC = PeopleViewController()
    lazy var messagesVC = MessagerViewController()
    lazy var profileVC = ProfileViewController()
    
    let headerOvalLayerMask = CAShapeLayer()
    let tabBarLayer = CAShapeLayer()
    let itemLayer = CAShapeLayer()
    var layerHeight = CGFloat()
    var layerWidth = CGFloat()
    let appearence = UITabBarAppearance()
    
    
    var tabBarLayerHorizontalPadding: CGFloat = 26
    var tabBarLayerVerticalPadding: CGFloat = 5
    
        

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupHeaderOvalLayer()
    }
    
    
    private func setupCardContainer() {
        let cardContainer = CardContainerView()
        
        view.addSubview(cardContainer)
    }
    
    /// TO-DO: complete floating tabbar setup 
    private func setupTabBar() {
        let regularConfiguration = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        let peopleTabBarImage = UIImage(systemName: "figure.wave", withConfiguration: regularConfiguration)!
        let messagesTabBarImage = UIImage(systemName: "message", withConfiguration: regularConfiguration)!
        let profileTabBarImage = UIImage(systemName: "person", withConfiguration: regularConfiguration)!
        
        setupVCTabBar(viewController: peopleVC, title: "Discover", image: peopleTabBarImage)
        setupVCTabBar(viewController: messagesVC, title: "Messages", image: messagesTabBarImage)
        setupVCTabBar(viewController: profileVC, title: "Profile", image: profileTabBarImage)
        
        tabBar.tintColor = UIColor(named: "selectedBarItemColor")!
        tabBar.backgroundColor = .clear
        viewControllers = [
            peopleVC,
            messagesVC,
            profileVC
        ]
        self.tabBar.itemPositioning = .centered
        
        setupTabBarLayer()
        setupItemLayer()
    }
    
    
    
    private func setupTabBarLayer() {
        let x: CGFloat = tabBarLayerHorizontalPadding
        let y: CGFloat = tabBarLayerVerticalPadding
        let width = self.tabBar.bounds.width - x * 2
        let height = CGFloat(Int(self.tabBar.bounds.height + y * 1.5))
        layerHeight = height
        layerWidth = width
        tabBarLayer.fillColor = UIColor.white.cgColor
        tabBarLayer.borderColor = UIColor.black.cgColor
        tabBarLayer.borderWidth = 0.1
        tabBarLayer.path = UIBezierPath(roundedRect: CGRect(x: x,
                                                      y: self.tabBar.bounds.minY - y * 0.5,
                                                      width: width,
                                                      height: height),
                                  cornerRadius: height / 2).cgPath
        
        tabBarLayer.shadowPath = tabBarLayer.path
        tabBarLayer.shadowColor = UIColor.black.cgColor
        tabBarLayer.shadowOffset = CGSize(width: 0, height: 1)
        tabBarLayer.shadowOpacity = 0.6
        
        self.tabBarLayer.shadowRadius = 4
        
        self.tabBar.layer.insertSublayer(tabBarLayer, at: 0)
    }
    
    private func setupItemLayer() {
        let width = layerWidth / 3
        let height = layerHeight - 4
        let x = tabBarLayerHorizontalPadding + 3
        
        
        
        
        itemLayer.fillColor = UIColor(named: "itemLayerColor")!.cgColor
        itemLayer.opacity = 0.69
        itemLayer.path = UIBezierPath(roundedRect: CGRect(x: x,
                                                          y: -0.5,
                                                          width: width,
                                                          height: height),
                                      cornerRadius: height /  2).cgPath
     
        tabBarLayer.insertSublayer(itemLayer, at: 0)
    }
    
    private func setupVCTabBar(viewController: UIViewController, title: String, image: UIImage) {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
    }
    
}
