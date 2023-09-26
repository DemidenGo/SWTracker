//
//  ViewController.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 05.08.2023.
//

import UIKit
import ProgressHUD

final class HomeViewController: UIViewController {

    private let viewModel: HomeViewModelProtocol
    private let notificationCenter: NotificationCenter

    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = L10n.Home.mainTitle
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()

    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.backgroundColor = .searchFieldBackground
        textField.placeholder = L10n.Home.searchPlaceholder
        textField.delegate = self
        return textField
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = L10n.Home.starWarsDescription
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()

    private lazy var resourcePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()

    private lazy var searchResultsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CharacterTableCell.self, forCellReuseIdentifier: CharacterTableCell.identifier)
        tableView.register(PlanetTableCell.self, forCellReuseIdentifier: PlanetTableCell.identifier)
        tableView.register(StarshipTableCell.self, forCellReuseIdentifier: StarshipTableCell.identifier)
        tableView.backgroundColor = .viewBackgroundColor
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private lazy var stubImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Images.emptyState
        return imageView
    }()

    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()

    init(viewModel: HomeViewModelProtocol = HomeViewModel()){
        self.viewModel = viewModel
        self.notificationCenter = NotificationCenter.default
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeAppearance()
        setupConstraints()
        bind()
        viewModel.viewDidLoad()
    }

    private func customizeAppearance() {
        view.backgroundColor = .viewBackgroundColor
        resourcePickerView.selectRow(Constants.maxPickerElement / 2, inComponent: 0, animated: false)
        ProgressHUD.mediaSize = 50
        ProgressHUD.marginSize = 25
    }

    private func bind() {
        viewModel.peopleObservable.bind { [weak self] _ in
            self?.searchResultsTableView.reloadData()
        }

        viewModel.planetsObservable.bind { [weak self] _ in
            self?.searchResultsTableView.reloadData()
        }

        viewModel.starshipsObservable.bind { [weak self] _ in
            self?.searchResultsTableView.reloadData()
        }

        viewModel.emptyStubLabelIsVisibleObservable.bind { [weak self] isVisible in
            if isVisible {
                self?.searchResultsTableView.isHidden = true
                self?.stubLabel.text = L10n.Home.emptyStateTitle
                self?.stubImageView.image = Images.emptyState
            } else {
                self?.searchResultsTableView.isHidden = false
            }
        }

        viewModel.notFoundStubLabelIsVisibleObservable.bind { [weak self] isVisible in
            if isVisible {
                self?.searchResultsTableView.isHidden = true
                self?.stubLabel.text = L10n.Home.notFoundStateTitle
                self?.stubImageView.image = Images.nothingFound
            }
        }

        viewModel.isSearchRequestProcessingObservable.bind { isProcessing in
            isProcessing ? UIBlockingProgressHUD.show() : UIBlockingProgressHUD.dismiss()
        }
    }

    private func setupConstraints() {
        [mainLabel,
         searchTextField,
         descriptionLabel,
         resourcePickerView,
         stubImageView,
         stubLabel,
         searchResultsTableView].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            mainLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            searchTextField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -view.bounds.width / 3),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),

            descriptionLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: mainLabel.leadingAnchor),

            resourcePickerView.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            resourcePickerView.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
            resourcePickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            resourcePickerView.heightAnchor.constraint(equalToConstant: 100),

            searchResultsTableView.topAnchor.constraint(equalTo: resourcePickerView.bottomAnchor),
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            stubImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 40),

            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}

// MARK: - UIPickerViewDataSource

extension HomeViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.maxPickerElement
    }
}

// MARK: - UIPickerViewDelegate

extension HomeViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = Resource.allCases[row % Resource.allCases.count].localizedString
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.didEnter(Resource.allCases[row % Resource.allCases.count])
    }
}

// MARK: - UITextFieldDelegate

extension HomeViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let searchRequest = textField.text {
            viewModel.didEnter(searchRequest)
        }
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.didClearSearchResults()
        textField.text = nil
        return true
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willDisplayCell(at: indexPath)
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.viewModelsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let characterCell = tableView.dequeueReusableCell(withIdentifier: CharacterTableCell.identifier) as? CharacterTableCell,
            let planetCell = tableView.dequeueReusableCell(withIdentifier: PlanetTableCell.identifier) as? PlanetTableCell,
            let starshipCell = tableView.dequeueReusableCell(withIdentifier: StarshipTableCell.identifier) as? StarshipTableCell
        else { return UITableViewCell() }

        switch viewModel.requestedResource {
        case .people:
            characterCell.setup(with: viewModel.people[indexPath.row])
            return characterCell
        case .planets:
            planetCell.setup(with: viewModel.planets[indexPath.row])
            return planetCell
        case .starships:
            starshipCell.setup(with: viewModel.starships[indexPath.row])
            return starshipCell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
}
