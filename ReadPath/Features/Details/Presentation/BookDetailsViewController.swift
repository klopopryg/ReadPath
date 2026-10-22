//
//  BookDetailsViewController.swift
//  ReadPath
//
//  Created by Егор on 02.10.2026.
//

import UIKit

final class BookDetailsViewController: UIViewController {
    private let bookDetailsViewModel: BookDetailsViewModel
    private let imageLoader: ImageLoaderProtocol
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let activityIndicator = UIActivityIndicatorView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let subjectsLabel = UILabel()
    private let libraryActionButton = UIButton()
    private var stackView = UIStackView()
    private let coverContainerView = UIView()
    private var loadTask: Task<Void, Never>?
    
    init(bookDetailsViewModel: BookDetailsViewModel, imageLoader: ImageLoaderProtocol) {
        self.bookDetailsViewModel = bookDetailsViewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        addSubViews()
        setupConstraints()
        setupAppearance()
        addActions()
        bindViewModel()
        bookDetailsViewModel.loadDetails()
    }
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(activityIndicator)
        contentView.addSubview(stackView)
        coverContainerView.addSubview(imageView)
        stackView.addArrangedSubview(coverContainerView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(subjectsLabel)
        stackView.addArrangedSubview(libraryActionButton)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: coverContainerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: coverContainerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: coverContainerView.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.5)
        ])
    }
    
    private func setupAppearance() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 24
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontForContentSizeCategory = true
        
        descriptionLabel.font = .preferredFont(forTextStyle: .body)
        descriptionLabel.textColor = .label
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.adjustsFontForContentSizeCategory = true
        
        subjectsLabel.font = .preferredFont(forTextStyle: .footnote)
        subjectsLabel.textColor = .secondaryLabel
        subjectsLabel.numberOfLines = 0
        subjectsLabel.adjustsFontForContentSizeCategory = true
        
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 16,
            bottom: 12,
            trailing: 16
        )
        libraryActionButton.configuration = configuration
        libraryActionButton.isEnabled = false
    }
    
    private func addActions() {
        libraryActionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        bookDetailsViewModel.toggleLibraryMemberShip()
    }
    
    private func showErrorAlert(massage: String) {
        let alert = UIAlertController(title: "Error", message: massage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func loadCover(from url: URL?) {
        loadTask?.cancel()
        imageView.image = UIImage(systemName: "text.book.closed")
        guard let url else { return }
        let imageLoader = imageLoader
        loadTask = Task { [weak self] in
            do {
                let loadedImage = try await imageLoader.loadImageFrom(url: url)
                guard !Task.isCancelled else { return }
                guard let self else { return }
                imageView.image = loadedImage
            } catch {
                return
            }
        }
    }
    
    private func updateLibraryButton(isInLibrary: Bool) {
        libraryActionButton.configuration?.title = isInLibrary
        ? "Remove from library"
        : "Add to library"
        
        libraryActionButton.isEnabled = true
    }
    
    func configureWith(details : BookDetails) {
        loadCover(from: details.coverURL)
        titleLabel.text = details.title
        descriptionLabel.text = details.description ?? "Description unavailable"
        subjectsLabel.text = details.subjects?.joined(separator: ", ") ?? "Subjects unavailable"
    }
    
    private func bindViewModel() {
        bookDetailsViewModel.onStateChanged = { [weak self] state in
            self?.handleState(state: state)
        }
        
        bookDetailsViewModel.onLibraryAction = { [weak self] action in
            self?.handleLibraryAction(action)
        }
    }
    
    private func handleState(state: DetailsState) {
        switch state {
        case .loading:
            libraryActionButton.isHidden = true
            imageView.isHidden = true
            activityIndicator.startAnimating()
        case .loaded(let details):
            libraryActionButton.isHidden = false
            activityIndicator.stopAnimating()
            imageView.isHidden = false
            configureWith(details: details)
        case .error(let message):
            activityIndicator.stopAnimating()
            imageView.isHidden = true
            libraryActionButton.isHidden = true
            showErrorAlert(massage: message)
        }
    }
    
    private func handleLibraryAction(_ action: LibraryActionResult) {
        switch action {
        case .memberShipChanged(isInLibrary: let isInLibrary):
            updateLibraryButton(isInLibrary: isInLibrary)
        case .error(let massage):
            showErrorAlert(massage: massage)
        }
    }
    
    deinit {
        loadTask?.cancel()
    }
}
