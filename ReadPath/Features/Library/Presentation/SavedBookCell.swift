//
//  SavedBookCell.swift
//  ReadPath
//
//  Created by Егор on 09.10.2026.
//

import UIKit

final class SavedBookCell: UITableViewCell {
    static let reuseIdentifier = "savedBookCell"
    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    private let verticalStackView = UIStackView()
    private let horizontalStackView = UIStackView()
    private let savedBookImageView = UIImageView()
    private var loadTask: Task<Void, Never>?
    private var currentCoverURL: URL?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAppearance()
        setupVerticalStackView()
        setupHorizontalStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVerticalStackView() {
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 4
        verticalStackView.alignment = .fill
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(statusLabel)
    }
    
    private func setupHorizontalStackView() {
        contentView.addSubview(horizontalStackView)
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 12
        horizontalStackView.alignment = .center
        horizontalStackView.addArrangedSubview(savedBookImageView)
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupAppearance() {
        savedBookImageView.image = UIImage(systemName: "text.book.closed")
        savedBookImageView.contentMode = .scaleAspectFit
        
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        statusLabel.font = .systemFont(ofSize: 14, weight: .medium)
        statusLabel.textColor = .secondaryLabel
        
        savedBookImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            savedBookImageView.widthAnchor.constraint(equalToConstant: 50),
            savedBookImageView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func chooseStatusTextColor(_ status: ReadingStatus) {
        switch status {
        case .wantToRead:
            statusLabel.textColor = .secondaryLabel
        case .reading:
            statusLabel.textColor = .systemBlue
        case .completed:
            statusLabel.textColor = .systemGreen
        }
    }
    
    func configure(with savedBook: SavedBook, imageLoader: ImageLoaderProtocol) {
        titleLabel.text = savedBook.title
        statusLabel.text = savedBook.status.rawValue
        chooseStatusTextColor(savedBook.status)
        let url = CoverURLBuilder.makeCoverURL(coverID: savedBook.coverID, size: .medium)
        guard currentCoverURL != url else { return }
        loadTask?.cancel()
        loadTask = nil
        currentCoverURL = url
        savedBookImageView.image = UIImage(systemName: "text.book.closed")
        guard let url else { return }
        loadTask = Task { [weak self] in
            do {
                let loadedImage = try await imageLoader.loadImageFrom(url: url)
                guard !Task.isCancelled else { return }
                guard let self, currentCoverURL == url else { return }
                savedBookImageView.image = loadedImage
            } catch {
                guard !Task.isCancelled else { return }
                guard let self, currentCoverURL == url else { return }
                currentCoverURL = nil
                loadTask = nil
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        statusLabel.text = ""
        savedBookImageView.image = UIImage(systemName: "text.book.closed")
        loadTask?.cancel()
        loadTask = nil
        currentCoverURL = nil
    }

}
