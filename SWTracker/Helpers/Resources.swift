//
//  Resources.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 08.08.2023.
//

import Foundation

enum Resource: String, CaseIterable {
    case people
    case planets
    case starships

    var localizedString: String {
        switch self {
        case .people: return L10n.People.title
        case .planets: return L10n.Planets.title
        case .starships: return L10n.Starships.title
        }
    }
}
