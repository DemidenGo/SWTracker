//
//  NetworkTask.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 09.08.2023.
//

import Foundation

protocol NetworkTask {
    func cancel()
}

struct SWNetworkTask: NetworkTask {
    let dataTask: URLSessionDataTask

    func cancel() {
        dataTask.cancel()
    }
}
