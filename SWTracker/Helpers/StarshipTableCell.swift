//
//  StarshipTableCell.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 08.08.2023.
//

import UIKit

final class StarshipTableCell: UITableViewCell {

    private lazy var starshipView: UIView = {
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
        label.textColor = .black
        return label
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
        [nameLabel].forEach { starshipView.addSubview($0) }
        contentView.addSubview(starshipView)
        NSLayoutConstraint.activate([
            starshipView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            starshipView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            starshipView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            starshipView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            nameLabel.topAnchor.constraint(equalTo: starshipView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: starshipView.leadingAnchor, constant: 12)
        ])
    }

    func setup(with starship: Starship) {
        nameLabel.text = starship.name
    }
}

