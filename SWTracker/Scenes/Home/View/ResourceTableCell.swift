//
//  SearchResultTableCell.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 07.08.2023.
//

import UIKit

final class ResourceTableCell: UITableViewCell {

    private lazy var resourceView: UIView = {
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

    private lazy var firstDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .mainFontColor.withAlphaComponent(0.8)
        return label
    }()

    private lazy var secondDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .mainFontColor.withAlphaComponent(0.8)
        return label
    }()

    private lazy var thirdDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
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
        [nameLabel,
         firstDescriptionLabel,
         secondDescriptionLabel,
         thirdDescriptionLabel,
         likeButton].forEach { resourceView.addSubview($0) }
        contentView.addSubview(resourceView)
        NSLayoutConstraint.activate([
            resourceView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            resourceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            resourceView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            resourceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            nameLabel.topAnchor.constraint(equalTo: resourceView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: resourceView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: resourceView.trailingAnchor, constant: -35),

            firstDescriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            firstDescriptionLabel.leadingAnchor.constraint(equalTo: resourceView.leadingAnchor, constant: 12),
            firstDescriptionLabel.trailingAnchor.constraint(equalTo: resourceView.trailingAnchor, constant: -12),

            secondDescriptionLabel.topAnchor.constraint(equalTo: firstDescriptionLabel.bottomAnchor, constant: 4),
            secondDescriptionLabel.leadingAnchor.constraint(equalTo: resourceView.leadingAnchor, constant: 12),
            secondDescriptionLabel.trailingAnchor.constraint(equalTo: resourceView.trailingAnchor, constant: -12),

            thirdDescriptionLabel.topAnchor.constraint(equalTo: secondDescriptionLabel.bottomAnchor, constant: 4),
            thirdDescriptionLabel.leadingAnchor.constraint(equalTo: resourceView.leadingAnchor, constant: 12),
            thirdDescriptionLabel.trailingAnchor.constraint(equalTo: resourceView.trailingAnchor, constant: -12),

            likeButton.topAnchor.constraint(equalTo: resourceView.topAnchor, constant: 10),
            likeButton.trailingAnchor.constraint(equalTo: resourceView.trailingAnchor, constant: -12)
        ])
    }

    @objc private func likeButtonAction() {
        // TODO: -
    }

    func setup(with resource: ResourceViewModel) {
        nameLabel.text = resource.name
        firstDescriptionLabel.text = resource.firstDescription
        secondDescriptionLabel.text = resource.secondDescription
        thirdDescriptionLabel.text = resource.thirdDescription
    }
}
