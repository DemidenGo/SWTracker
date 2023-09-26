//
//  PlanetTableCell.swift
//  SWTracker
//
//  Created by Юрий Демиденко on 08.08.2023.
//

import UIKit

final class PlanetTableCell: UITableViewCell {

    private lazy var planetView: UIView = {
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
        label.font = .boldSystemFont(ofSize: 26)
        label.textColor = .mainFontColor
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
        [nameLabel].forEach { planetView.addSubview($0) }
        contentView.addSubview(planetView)
        NSLayoutConstraint.activate([
            planetView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            planetView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            planetView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            planetView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            nameLabel.topAnchor.constraint(equalTo: planetView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: planetView.leadingAnchor, constant: 12)
        ])
    }

    func setup(with planet: Planet) {
        nameLabel.text = planet.name
    }
}
