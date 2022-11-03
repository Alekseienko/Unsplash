//
//  MainTabBarViewController.swift
//  Unsplash
//
//  Created by alekseienko on 30.10.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        setupControllers()
    }
    

    // MARK: - GENERATE COLLECTION VIEW CONTROLLER
    private func generateVC(collectionController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: collectionController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
    
    // MARK: - SETUP CONTROLLERS
    private func setupControllers() {
        let homeVC = HomeViewController()
        let favouriteVC = FavouriteViewController()
        viewControllers = [
            generateVC(
            collectionController: homeVC,
            title: "Home",
            image: UIImage(named: "tab-home")),
            generateVC(
            collectionController: favouriteVC,
            title: "Favourite",
            image: UIImage(named: "tab-heart"))
        ]
    }
}
