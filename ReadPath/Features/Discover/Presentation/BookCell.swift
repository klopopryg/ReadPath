//
//  BookCell.swift
//  ReadPath
//
//  Created by Егор on 28.09.2026.
//

import UIKit

final class BookCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private var imageLoadingTask: Task<Void, Never>?
    static let reuseIdentifier = "bookCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
    }
    
    func configure(book: Book, imageLoader: ImageLoaderProtocol) {
        imageView.image = UIImage(systemName: "text.book.closed")
        imageLoadingTask?.cancel()
         imageLoadingTask = Task {
            do {
                if let url = book.coverURL {
                    let image = try await imageLoader.loadImageFrom(url: url)
                    guard !Task.isCancelled else { return }
                    imageView.image = image
                } else {
                    imageView.image = UIImage(systemName: "text.book.closed")
                }
            } catch {
                guard !Task.isCancelled else { return }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadingTask?.cancel()
        imageLoadingTask = nil
        imageView.image = nil
    }
}
