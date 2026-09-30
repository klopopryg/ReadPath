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
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.reuseIdentifier)
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
    
    private func showErrorAlertWith(massage: String) {
        let alert = UIAlertController(title: "Loading Error", message: massage, preferredStyle: .alert)
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
            collectionView.isHidden = false
            searchController.searchBar.isHidden = false
        case .loaded:
            emptyLabel.isHidden = true
            activityIndicator.stopAnimating()
            collectionView.isHidden = false
            searchController.searchBar.isHidden = false
            collectionView.reloadData()
        case .empty(let query):
            activityIndicator.stopAnimating()
            collectionView.isHidden = true
            emptyLabel.isHidden = false
            emptyLabel.text = "No books found \(query)"
        case .loadingMore:
            break
        case .error(let massage):
            collectionView.isHidden = true
            activityIndicator.stopAnimating()
            showErrorAlertWith(massage: massage)
        }
    }
}

extension DiscoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        discoverViewModel.getBooksCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookCell.reuseIdentifier, for: indexPath
        ) as? BookCell else {
            return UICollectionViewCell()
        }
        let currentBook = discoverViewModel.books[indexPath.row]
        cell.configureWith(book: currentBook, and: imageLoader)
        return cell
    }
}

extension DiscoverViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension DiscoverViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text
        discoverViewModel.search(query: query)
        searchBar.resignFirstResponder()
    }
}

