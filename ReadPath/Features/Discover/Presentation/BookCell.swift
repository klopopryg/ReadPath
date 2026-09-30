//
//  BookCell.swift
//  ReadPath
//
//  Created by Егор on 28.09.2026.
//

import UIKit

final class BookCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private var task: Task<Void, Never>?
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
    }
    
    func configureWith(book: Book, and imageLoader: ImageLoaderProtocol) {
        task?.cancel()
         task = Task {
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
                imageView.image = UIImage(systemName: "text.book.closed")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        task = nil
        imageView.image = nil
    }
}
