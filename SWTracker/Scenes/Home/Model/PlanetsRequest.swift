//
//  PlanetsRequest.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 14.08.2023.
//

import Foundation

struct PlanetsRequest: NetworkRequest {
    let endpoint: URL?
    let httpMethod: HttpMethod
    let queryParameters: [String : String]?

    init(queryParameters: [String : String]?) {
        self.endpoint = URL(string: Constants.baseURLString + Resource.planets.rawValue)
        self.httpMethod = .get
        self.queryParameters = queryParameters
    }
}
