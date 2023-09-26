//
//  Colors.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 06.08.2023.
//

import UIKit

extension UIColor {
    static let viewBackgroundColor = UIColor.systemBackground
    static var mainAppColor: UIColor { UIColor(named: "MainAppColor") ?? .systemYellow }
    static var mainFontColor: UIColor { UIColor(named: "MainFontColor") ?? .black }
    static var searchFieldBackground: UIColor { UIColor(named: "SearchFieldBackground") ?? .systemGray6 }
    static var likeColor: UIColor { UIColor(named: "LikeColor") ?? .systemRed }
    static var unlikeColor: UIColor { UIColor(named: "UnlikeColor") ?? .systemGray6 }
}
