//
//  SearchResultTableCell.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 07.08.2023.
//

import UIKit

final class CharacterTableCell: UITableViewCell {

    private lazy var characterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .mainAppColor
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .mainFontColor
        return label
    }()

    private lazy var numberOfStarshipsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .mainFontColor.withAlphaComponent(0.8)
        return label
    }()

    private lazy var numberOfVehiclesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .mainFontColor.withAlphaComponent(0.8)
        return label
    }()

    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .mainFontColor.withAlphaComponent(0.8)
        return label
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Images.heartImage?.withTintColor(.unlikeColor, renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(Images.heartImage?.withTintColor(.likeColor, renderingMode: .alwaysOriginal), for: .highlighted)
        button.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
        button.accessibilityIdentifier = "like"
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .viewBackgroundColor
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        [nameLabel, numberOfStarshipsLabel, genderLabel, likeButton].forEach { characterView.addSubview($0) }
        contentView.addSubview(characterView)
        NSLayoutConstraint.activate([
            characterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            characterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            characterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            characterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            nameLabel.topAnchor.constraint(equalTo: characterView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: characterView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: characterView.trailingAnchor, constant: -35),

            numberOfStarshipsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            numberOfStarshipsLabel.leadingAnchor.constraint(equalTo: characterView.leadingAnchor, constant: 12),

            genderLabel.topAnchor.constraint(equalTo: numberOfStarshipsLabel.bottomAnchor, constant: 4),
            genderLabel.leadingAnchor.constraint(equalTo: characterView.leadingAnchor, constant: 12),

            likeButton.topAnchor.constraint(equalTo: characterView.topAnchor, constant: 10),
            likeButton.trailingAnchor.constraint(equalTo: characterView.trailingAnchor, constant: -12)
        ])
    }

    @objc private func likeButtonAction() {
        
    }

    func setup(with character: Character) {
        nameLabel.text = character.name
        numberOfStarshipsLabel.text = character.numberOfStarships
        genderLabel.text = character.gender
    }
}
