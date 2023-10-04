//
//  PeopleModel.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 09.08.2023.
//

import Foundation

struct PeopleModel: Decodable {
    let next: String?
    let results: [CharacterModel]
}

struct CharacterModel: Decodable {
    let name: String
    let gender: String
    let starships: [String]
    let vehicles: [String]
}
