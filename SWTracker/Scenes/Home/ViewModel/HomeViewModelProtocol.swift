//
//  HomeViewModelProtocol.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 06.08.2023.
//

import Foundation

protocol HomeViewModelProtocol {
    var viewModelsCount: Int { get }
    var requestedResource: Resource { get }
    var people: [Character] { get }
    var planets: [Planet] { get }
    var starships: [Starship] { get }
    var peopleObservable: Observable<[Character]> { get }
    var planetsObservable: Observable<[Planet]> { get }
    var starshipsObservable: Observable<[Starship]> { get }
    var emptyStubLabelIsVisibleObservable: Observable<Bool> { get }
    var notFoundStubLabelIsVisibleObservable: Observable<Bool> { get }
    var isSearchRequestProcessingObservable: Observable<Bool> { get }

    func viewDidLoad()
    func didEnter(_ resource: Resource)
    func didEnter(_ searchRequest: String)
    func didClearSearchResults()
    func willDisplayCell(at indexPath: IndexPath)
}
