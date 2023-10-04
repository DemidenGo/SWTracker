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
        //  TODO: -
        // case notFound
    }

    private let resourcesStore: ResourceStoreProtocol

    @Observable
    private(set) var resourceViewModels: [ResourceViewModel]
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
        self.resourceViewModels = []
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
            ResourceViewModel(name: $0.name,
                              firstDescription: L10n.People.genderTitle + $0.gender,
                              secondDescription: L10n.People.pilotedStarshipsTitle + String($0.starships.count),
                              thirdDescription: L10n.People.vehiclesTitle + String($0.vehicles.count))
        }
        resourceViewModels.append(contentsOf: newPeople)
        nextPageURLString = peopleModel.next
        state = .showResult
    }

    private func setPlanetsViewModel(from planetsModel: PlanetsModel) {
        let newPlanets = planetsModel.results.map {
            ResourceViewModel(name: $0.name,
                              firstDescription: L10n.Planets.populationTitle + $0.population,
                              secondDescription: L10n.Planets.diameterTitle + $0.diameter,
                              thirdDescription: L10n.Planets.gravityTitle + $0.gravity.prefix { $0 != " " })
        }
        resourceViewModels.append(contentsOf: newPlanets)
        nextPageURLString = planetsModel.next
        state = .showResult
    }

    private func setStarshipsViewModel(from starshipsModel: StarshipsModel) {
        let newStarships = starshipsModel.results.map {
            ResourceViewModel(name: $0.name,
                              firstDescription: L10n.Starships.modelTitle + $0.model,
                              secondDescription: L10n.Starships.manufacturerTitle + $0.manufacturer,
                              thirdDescription: L10n.Starships.passengersTitle + $0.passengers)
        }
        resourceViewModels.append(contentsOf: newStarships)
        nextPageURLString = starshipsModel.next
        state = .showResult
    }

    private func handle(_ error: Error) {
        isSearchRequestProcessing = false
        // TODO: -
    }

    private func switchToEmptyState() {
        resourceViewModels = []
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
            notFoundStubLabelIsVisible = resourceViewModels.isEmpty
        }
    }

    private func cancelPreviousAPICall() {
        HomeViewModel.cancelPreviousPerformRequests(withTarget: self,
                                                    selector: #selector(apiCall),
                                                    object: searchRequest)
    }

    private func fetchNextResourcePage(at urlString: String) {
        switch requestedResource {
        case .people:
            resourcesStore.fetchPeople(at: urlString) { [weak self] result in
                switch result {
                case .success(let peopleModel): self?.setPeopleViewModel(from: peopleModel)
                case .failure(let error): self?.handle(error)
                }
            }
        case .planets:
            resourcesStore.fetchPlanets(at: urlString) { [weak self] result in
                switch result {
                case .success(let planetsModel): self?.setPlanetsViewModel(from: planetsModel)
                case .failure(let error): self?.handle(error)
                }
            }
        case .starships:
            resourcesStore.fetchStarships(at: urlString) { [weak self] result in
                switch result {
                case .success(let starshipsModel): self?.setStarshipsViewModel(from: starshipsModel)
                case .failure(let error): self?.handle(error)
                }
            }
        }
    }
}

// MARK: - HomeViewModelProtocol

extension HomeViewModel: HomeViewModelProtocol {

    var resourceViewModelsObservable: Observable<[ResourceViewModel]> { $resourceViewModels }
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
            resourceViewModels = []
            apiCall(searchRequest)
        }
    }

    func didClearSearchResults() {
        state = .empty
    }

    func willDisplayCell(at indexPath: IndexPath) {
        guard
            indexPath.row + 1 == resourceViewModels.count,
            let nextPageURLString = nextPageURLString
        else { return }
        isSearchRequestProcessing = true
        fetchNextResourcePage(at: nextPageURLString)
    }
}
