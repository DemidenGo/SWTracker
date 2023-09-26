//
//  StarshipsModel.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 14.08.2023.
//

import Foundation

struct StarshipsModel: Decodable {
    let next: String?
    let results: [StarshipModel]
}

struct StarshipModel: Decodable {
    let name: String
    let model: String
    let manufacturer: String
    let passengers: String
}
