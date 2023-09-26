//
//  PlanetsModel.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 13.08.2023.
//

import Foundation

struct PlanetsModel: Decodable {
    let next: String?
    let results: [PlanetModel]
}

struct PlanetModel: Decodable {
    let name: String
    let diameter: String
    let population: String
}
