//
//  HomeViewModelProtocol.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 06.08.2023.
//

import Foundation

protocol HomeViewModelProtocol {

    var requestedResource: Resource { get }
    var resourceViewModels: [ResourceViewModel] { get }
    var resourceViewModelsObservable: Observable<[ResourceViewModel]> { get }
    var emptyStubLabelIsVisibleObservable: Observable<Bool> { get }
    var notFoundStubLabelIsVisibleObservable: Observable<Bool> { get }
    var isSearchRequestProcessingObservable: Observable<Bool> { get }

    func viewDidLoad()
    func didEnter(_ resource: Resource)
    func didEnter(_ searchRequest: String)
    func didClearSearchResults()
    func willDisplayCell(at indexPath: IndexPath)
}
