//
//  HomeViewModel.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 06.08.2023.
//

import Foundation

final class HomeViewModel: NSObject {

    private enum State {
        case empty, search, showResult
    }

    private let resourcesStore: ResourceStoreProtocol

    @Observable
    private(set) var people: [Character]
    @Observable
    private(set) var planets: [Planet]
    @Observable
    private(set) var starships: [Starship]
    @Observable
    private var emptyStubLabelIsVisible: Bool
    @Observable
    private var notFoundStubLabelIsVisible: Bool
    @Observable
    private var isSearchRequestProcessing: Bool

    private(set) var requestedResource: Resource
    private var searchRequest: String?
    private var nextPageURLString: String?

    private var state: State {
        didSet {
            switch state {
            case .empty: switchToEmptyState()
            case .search: switchToSearchState()
            case .showResult: switchToShowResultState()
            }
        }
    }

    init(resourcesStore: ResourceStoreProtocol = ResourcesStore()) {
        self.resourcesStore = resourcesStore
        self.people = []
        self.planets = []
        self.starships = []
        self.state = .empty
        self.requestedResource = .starships
        self.emptyStubLabelIsVisible = false
        self.notFoundStubLabelIsVisible = false
        self.isSearchRequestProcessing = false
    }

    @objc private func apiCall(_ searchRequest: String) {
        state = .search
        switch requestedResource {
        case .people: requestPeople(for: searchRequest)
        case .planets: requestPlanets(for: searchRequest)
        case .starships: requestStarships(for: searchRequest)
        }
    }

    private func requestPeople(for searchRequest: String) {
        resourcesStore.fetchPeople(for: searchRequest) { [weak self] result in
            switch result {
            case .success(let peopleModel): self?.setPeopleViewModel(from: peopleModel)
            case .failure(let error): self?.handle(error)
            }
        }
    }

    private func requestPlanets(for searchRequest: String) {
        resourcesStore.fetchPlanets(for: searchRequest) { [weak self] result in
            switch result {
            case .success(let planetsModel): self?.setPlanetsViewModel(from: planetsModel)
            case .failure(let error): self?.handle(error)
            }
        }
    }

    private func requestStarships(for searchRequest: String) {
        resourcesStore.fetchStarships(for: searchRequest) { [weak self] result in
            switch result {
            case .success(let starshipsModel): self?.setStarshipsViewModel(from: starshipsModel)
            case .failure(let error): self?.handle(error)
            }
        }
    }

    private func setPeopleViewModel(from peopleModel: PeopleModel) {
        let newPeople = peopleModel.results.map {
            Character(name: $0.name,
                      gender: L10n.People.genderTitle + $0.gender,
                      numberOfStarships: L10n.People.pilotedStarshipsTitle + String($0.starships.count))
        }
        people.append(contentsOf: newPeople)
        nextPageURLString = peopleModel.next
        state = .showResult
    }

    private func setPlanetsViewModel(from planetsModel: PlanetsModel) {
        let newPlanets = planetsModel.results.map {
            Planet(name: $0.name,
                   diameter: $0.diameter,
                   population: $0.population)
        }
        planets.append(contentsOf: newPlanets)
        nextPageURLString = planetsModel.next
        state = .showResult
    }

    private func setStarshipsViewModel(from starshipsModel: StarshipsModel) {
        let newStarships = starshipsModel.results.map {
            Starship(name: $0.name,
                     model: $0.model,
                     manufacturer: $0.manufacturer,
                     passengers: $0.passengers)
        }
        starships.append(contentsOf: newStarships)
        nextPageURLString = starshipsModel.next
        state = .showResult
    }

    private func handle(_ error: Error) {
        isSearchRequestProcessing = false
    }

    private func eraseViewModels() {
        switch requestedResource {
        case .people: people = []
        case .planets: planets = []
        case .starships: starships = []
        }
    }

    private func switchToEmptyState() {
        eraseViewModels()
        emptyStubLabelIsVisible = true
        searchRequest = nil
        nextPageURLString = nil
    }

    private func switchToSearchState() {
        emptyStubLabelIsVisible = false
        isSearchRequestProcessing = true
    }

    private func switchToShowResultState() {
        isSearchRequestProcessing = false
        if nextPageURLString == nil {
            switch requestedResource {
            case .people: notFoundStubLabelIsVisible = people.isEmpty
            case .planets: notFoundStubLabelIsVisible = planets.isEmpty
            case .starships: notFoundStubLabelIsVisible = starships.isEmpty
            }
        }
    }

    private func cancelPreviousAPICall() {
        HomeViewModel.cancelPreviousPerformRequests(withTarget: self,
                                                    selector: #selector(apiCall),
                                                    object: searchRequest)
    }
}

// MARK: - HomeViewModelProtocol

extension HomeViewModel: HomeViewModelProtocol {

    var viewModelsCount: Int {
        switch requestedResource {
        case .people: return people.count
        case .planets: return planets.count
        case .starships: return starships.count
        }
    }

    var peopleObservable: Observable<[Character]> { $people }
    var planetsObservable: Observable<[Planet]> { $planets }
    var starshipsObservable: Observable<[Starship]> { $starships }
    var emptyStubLabelIsVisibleObservable: Observable<Bool> { $emptyStubLabelIsVisible }
    var notFoundStubLabelIsVisibleObservable: Observable<Bool> { $notFoundStubLabelIsVisible }
    var isSearchRequestProcessingObservable: Observable<Bool> { $isSearchRequestProcessing }

    func viewDidLoad() {
        state = .empty
    }

    func didEnter(_ searchRequest: String) {
        if searchRequest.count >= 2 {
            cancelPreviousAPICall()
            perform(#selector(apiCall), with: searchRequest, afterDelay: Constants.apiCallDelay)
            self.searchRequest = searchRequest
        } else {
            cancelPreviousAPICall()
            switchToEmptyState()
        }
    }

    func didEnter(_ resource: Resource) {
        guard requestedResource != resource else { return }
        requestedResource = resource
        if let searchRequest = searchRequest {
            eraseViewModels()
            apiCall(searchRequest)
        }
    }

    func didClearSearchResults() {
        state = .empty
    }

    func willDisplayCell(at indexPath: IndexPath) {
        guard let nextPageURLString = nextPageURLString else { return }
        switch requestedResource {
        case .people:
            if indexPath.row + 1 == people.count {
                isSearchRequestProcessing = true
                resourcesStore.fetchPeople(at: nextPageURLString) { [weak self] result in
                    switch result {
                    case .success(let peopleModel): self?.setPeopleViewModel(from: peopleModel)
                    case .failure(let error): self?.handle(error)
                    }
                }
            }
        case .planets:
            if indexPath.row + 1 == planets.count {
                isSearchRequestProcessing = true
                resourcesStore.fetchPlanets(at: nextPageURLString) { [weak self] result in
                    switch result {
                    case .success(let planetsModel): self?.setPlanetsViewModel(from: planetsModel)
                    case .failure(let error): self?.handle(error)
                    }
                }
            }
        case .starships:
            if indexPath.row + 1 == starships.count {
                isSearchRequestProcessing = true
                resourcesStore.fetchStarships(at: nextPageURLString) { [weak self] result in
                    switch result {
                    case .success(let starshipsModel): self?.setStarshipsViewModel(from: starshipsModel)
                    case .failure(let error): self?.handle(error)
                    }
                }
            }
        }
    }
}
