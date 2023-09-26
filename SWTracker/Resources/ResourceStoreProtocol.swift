//
//  ResourceStoreProtocol.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 09.08.2023.
//

import Foundation

protocol ResourceStoreProtocol {
    func fetchPeople(for searchRequest: String, completion: @escaping ((Result<PeopleModel,Error>) -> Void))
    func fetchPeople(at urlString: String, completion: @escaping ((Result<PeopleModel,Error>) -> Void))
    func fetchPlanets(for searchRequest: String, completion: @escaping ((Result<PlanetsModel,Error>) -> Void))
    func fetchPlanets(at urlString: String, completion: @escaping ((Result<PlanetsModel,Error>) -> Void))
    func fetchStarships(for searchRequest: String, completion: @escaping ((Result<StarshipsModel,Error>) -> Void))
    func fetchStarships(at urlString: String, completion: @escaping ((Result<StarshipsModel,Error>) -> Void))
}
