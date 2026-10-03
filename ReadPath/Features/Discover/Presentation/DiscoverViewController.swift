//
//  ViewController.swift
//  ReadPath
//
//  Created by Егор on 27.09.2026.
//

import UIKit

class DiscoverViewController: UIViewController {
    private let imageLoader: ImageLoaderProtocol
    private let discoverViewModel: DiscoverViewModel
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    private let searchController = UISearchController()
    private let activityIndicator = UIActivityIndicatorView()
    private let emptyLabel = UILabel()
    private var isLoadingMore = false
    var onBookSelected: ((String) -> Void)?
    
    init(discoverViewModel: DiscoverViewModel, imageLoader: ImageLoaderProtocol) {
        self.discoverViewModel = discoverViewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        setupCollectionView()
        setupNavigation()
        setupActivityIndicator()
        setupEmptyLabel()
        bindViewModel()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            BookCell.self,
            forCellWithReuseIdentifier: BookCell.reuseIdentifier
        )
        collectionView.register(
            LoadingFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LoadingFooterView.reusableIdentifier
        )
    }
    
    private func setupNavigation() {
        searchController.searchBar.placeholder = "Search books..."
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        emptyLabel.isHidden = true
    }
    
    private func showLoadingErrorAlertWith(message: String) {
        let alert = UIAlertController(
            title: "Loading Error",
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func showNextPageErrorAlert(massage: String) {
        let alert = UIAlertController(
            title: "Loading next page error",
            message: massage,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func bindViewModel() {
        discoverViewModel.onStateChanged = { [weak self] state in
            self?.handleState(state: state)
        }
    }
    
    private func handleState(state: DiscoverState) {
        switch state {
        case .idle:
            break
        case .loading:
            emptyLabel.isHidden = true
            activityIndicator.startAnimating()
            collectionView.isHidden = true
        case .loaded:
            emptyLabel.isHidden = true
            activityIndicator.stopAnimating()
            collectionView.isHidden = false
            searchController.searchBar.isHidden = false
            isLoadingMore = false
            collectionView.reloadData()
        case .empty(let query):
            activityIndicator.stopAnimating()
            collectionView.isHidden = true
            emptyLabel.isHidden = false
            emptyLabel.text = "No books found \(query)"
        case .loadingMore:
            isLoadingMore = true
            collectionView.collectionViewLayout.invalidateLayout()
        case .loadingError(let message):
            collectionView.isHidden = true
            isLoadingMore = false
            activityIndicator.stopAnimating()
            showLoadingErrorAlertWith(message: message)
        case .nextPageError(let massage):
            isLoadingMore = false
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.isHidden = false
            showNextPageErrorAlert(massage: massage)
        case .loadedNextPage(let range):
            let indexPaths = range.map {
                IndexPath(item: $0, section: 0)
            }
            isLoadingMore = false
            collectionView.insertItems(at: indexPaths)
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
}

extension DiscoverViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        discoverViewModel.getBooksCount()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookCell.reuseIdentifier, for: indexPath
        ) as? BookCell else {
            return UICollectionViewCell()
        }
        let currentBook = discoverViewModel.books[indexPath.row]
        cell.configure(book: currentBook, imageLoader: imageLoader)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: LoadingFooterView.reusableIdentifier,
            for: indexPath
        ) as? LoadingFooterView else { return UICollectionReusableView() }
        
        if isLoadingMore {
            footer.startAnimating()
        } else {
            footer.stopAnimating()
        }
        return footer
    }
}

extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let currentBook = discoverViewModel.getBookAt(index: indexPath.item)
        let currentBookId = currentBook.key
        onBookSelected?(currentBookId)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.frame.height
        let offsetY = scrollView.contentOffset.y
        let distanceFromBottom = contentHeight - visibleHeight - offsetY
        
        if distanceFromBottom < 300 {
            discoverViewModel.loadNextPage()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        let columns: CGFloat = 2
        let leftInset = layout.sectionInset.left
        let rightInset = layout.sectionInset.right
        let horizontalInsets = leftInset + rightInset
        let spacingBetweenCells = layout.minimumInteritemSpacing * (columns - 1)
        let availableWidth = collectionView.bounds.width - horizontalInsets - spacingBetweenCells
        let itemWidth = availableWidth / columns
        let itemHeight = itemWidth * 1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        if isLoadingMore {
            return CGSize(width: collectionView.bounds.width, height: 50)
        } else {
            return .zero
        }
    }
}

extension DiscoverViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text
        discoverViewModel.search(query: query)
        searchBar.resignFirstResponder()
    }
}
