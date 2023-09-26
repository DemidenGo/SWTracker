//
//  ResourcesStore.swift.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 09.08.2023.
//

import Foundation

final class ResourcesStore {

    private let networkClient: NetworkClient
    private var networkTask: NetworkTask?

    init(networkClient: NetworkClient = SWNetworkClient()) {
        self.networkClient = networkClient
    }

    private func makeQueryParameters(from urlString: String) -> [String : String]? {
        guard let url = URL(string: urlString),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems,
              queryItems.count >= 2 else { return nil }
        var queryParameters: [String : String] = [:]
        queryItems.forEach { queryParameters[$0.name] = $0.value }
        return queryParameters
    }
}

extension ResourcesStore: ResourceStoreProtocol {

    // MARK: - People resource

    func fetchPeople(for searchRequest: String, completion: @escaping ((Result<PeopleModel,Error>) -> Void)) {
        networkTask?.cancel()
        let request = PeopleRequest(queryParameters: ["search": searchRequest])
        networkTask = networkClient.send(request: request, type: PeopleModel.self) { result in
            DispatchQueue.main.async { completion(result) }
        }
    }

    func fetchPeople(at urlString: String, completion: @escaping ((Result<PeopleModel,Error>) -> Void)) {
        guard let queryParameters = makeQueryParameters(from: urlString) else { return }
        networkTask?.cancel()
        let request = PeopleRequest(queryParameters: queryParameters)
        networkTask = networkClient.send(request: request, type: PeopleModel.self) { result in
            DispatchQueue.main.async { completion(result) }
        }
    }

    // MARK: - Planets resource

    func fetchPlanets(for searchRequest: String, completion: @escaping ((Result<PlanetsModel,Error>) -> Void)) {
        networkTask?.cancel()
        let request = PlanetsRequest(queryParameters: ["search": searchRequest])
        networkTask = networkClient.send(request: request, type: PlanetsModel.self) { result in
            DispatchQueue.main.async { completion(result) }
        }
    }

    func fetchPlanets(at urlString: String, completion: @escaping ((Result<PlanetsModel,Error>) -> Void)) {
        guard let queryParameters = makeQueryParameters(from: urlString) else { return }
        networkTask?.cancel()
        let request = PlanetsRequest(queryParameters: queryParameters)
        networkTask = networkClient.send(request: request, type: PlanetsModel.self) { result in
            DispatchQueue.main.async { completion(result) }
        }
    }

    // MARK: - Starships resource

    func fetchStarships(for searchRequest: String, completion: @escaping ((Result<StarshipsModel, Error>) -> Void)) {
        networkTask?.cancel()
        let request = StarshipsRequest(queryParameters: ["search": searchRequest])
        networkTask = networkClient.send(request: request, type: StarshipsModel.self) { result in
            DispatchQueue.main.async { completion(result) }
        }
    }

    func fetchStarships(at urlString: String, completion: @escaping ((Result<StarshipsModel, Error>) -> Void)) {
        guard let queryParameters = makeQueryParameters(from: urlString) else { return }
        networkTask?.cancel()
        let request = StarshipsRequest(queryParameters: queryParameters)
        networkTask = networkClient.send(request: request, type: StarshipsModel.self) { result in
            DispatchQueue.main.async { completion(result) }
        }
    }
}
