//
//  TabBarController.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 05.08.2023.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
    }

    private func setupTabBarController() {
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: L10n.Home.tabBarTitle,
                                                     image: Images.homeTabBarItem,
                                                     selectedImage: nil)
        let favoritesViewController = FavoritesViewController()
        favoritesViewController.tabBarItem = UITabBarItem(title: L10n.Favorites.tabBarTitle,
                                                          image: Images.favoritesTabBarItem,
                                                          selectedImage: nil)
        viewControllers = [homeViewController, favoritesViewController]
    }
}
