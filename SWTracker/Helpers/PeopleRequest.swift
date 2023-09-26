//
//  PeopleRequest.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 09.08.2023.
//

import Foundation

struct PeopleRequest: NetworkRequest {
    let endpoint: URL?
    let httpMethod: HttpMethod
    let queryParameters: [String : String]?

    init(queryParameters: [String : String]?) {
        self.endpoint = URL(string: Constants.baseURLString + Resource.people.rawValue)
        self.httpMethod = .get
        self.queryParameters = queryParameters
    }
}
