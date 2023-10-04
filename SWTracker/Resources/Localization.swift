//
//  L10n.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 05.08.2023.
//

import Foundation

enum L10n {
    enum Home {
        static let tabBarTitle = NSLocalizedString("homeTitle", comment: "Tab bar item title")
        static let mainTitle = NSLocalizedString("starWarsTitle", comment: "Main screen title")
        static let starWarsDescription = NSLocalizedString("starWarsDescription", comment: "SWTracker description")
        static let searchPlaceholder = NSLocalizedString("searchPlaceholder", comment: "Search field placeholder")
        static let emptyStateTitle = NSLocalizedString("emptyStateTitle", comment: "Title for empty state")
        static let notFoundStateTitle = NSLocalizedString("notFoundStateTitle", comment: "Empty search result title")
    }
    enum Favorites {
        static let tabBarTitle = NSLocalizedString("favoritesTitle", comment: "Tab bar item title")
    }
    enum People {
        static let title = NSLocalizedString("peopleTitle", comment: "Title for header in section")
        static let pilotedStarshipsTitle = NSLocalizedString("pilotedStarshipsTitle", comment: "Piloted starships title")
        static let vehiclesTitle = NSLocalizedString("vehiclesTitle", comment: "Characters vehicles title")
        static let genderTitle = NSLocalizedString("genderTitle", comment: "Character gender title")
    }
    enum Planets {
        static let title = NSLocalizedString("planetsTitle", comment: "Title for header in section")
        static let diameterTitle = NSLocalizedString("diameterTitle", comment: "Planet diameter title")
        static let populationTitle = NSLocalizedString("populationTitle", comment: "Planet population title")
        static let gravityTitle = NSLocalizedString("gravityTitle", comment: "Planet gravity title")
    }
    enum Starships {
        static let title = NSLocalizedString("starshipsTitle", comment: "Title for header in section")
        static let modelTitle = NSLocalizedString("modelTitle", comment: "Starship model title")
        static let manufacturerTitle = NSLocalizedString("manufacturerTitle", comment: "Starship manufacturer title")
        static let passengersTitle = NSLocalizedString("passengersTitle", comment: "Starship passengers title")
    }
}
