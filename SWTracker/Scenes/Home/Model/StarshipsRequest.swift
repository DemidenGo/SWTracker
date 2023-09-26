//
//  StarshipsRequest.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 14.08.2023.
//

import Foundation

struct StarshipsRequest: NetworkRequest {
    let endpoint: URL?
    let httpMethod: HttpMethod
    let queryParameters: [String : String]?

    init(queryParameters: [String : String]?) {
        self.endpoint = URL(string: Constants.baseURLString + Resource.starships.rawValue)
        self.httpMethod = .get
        self.queryParameters = queryParameters
    }
}
