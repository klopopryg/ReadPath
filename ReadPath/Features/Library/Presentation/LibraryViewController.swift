//
//  LibraryViewController.swift
//  ReadPath
//
//  Created by Егор on 27.09.2026.
//

import UIKit

final class LibraryViewController: UIViewController {
    private let libraryViewModel: LibraryViewModel
    private let imageLoader: ImageLoaderProtocol
    private let tableView = UITableView()
    private let segmentedControl = UISegmentedControl(
        items: ["All", "Want to read", "Reading", "Completed"]
    )
    private let emptyStateLabel = UILabel()
    var onBookSelected: ((String) -> Void)?
    
    init(libraryViewModel: LibraryViewModel, imageLoader: ImageLoaderProtocol) {
        self.libraryViewModel = libraryViewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        setupTableView()
        setupEmptyStateLabel()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        libraryViewModel.loadBooks()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.backgroundView = emptyStateLabel
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SavedBookCell.self, forCellReuseIdentifier: SavedBookCell.reuseIdentifier)
    }
    
    private func setupEmptyStateLabel() {
        emptyStateLabel.text = "No books in this section"
        emptyStateLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        emptyStateLabel.textColor = .secondaryLabel
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
    }
    
    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
    }
    
    @objc private func filterChanged(_ sender: UISegmentedControl) {
        let filter: LibraryFilter
        switch sender.selectedSegmentIndex {
        case 0:
            filter = .all
        case 1:
            filter = .wantToRead
        case 2:
            filter = .reading
        case 3:
            filter = .completed
        default:
            return
        }
        libraryViewModel.setFilter(filter)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func showStatusSelection(book: SavedBook, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Change reading status", message: nil, preferredStyle: .actionSheet)
        let wantToRead = UIAlertAction(title: book.status == .wantToRead ? "Want to read (Current)" : "Want to read", style: .default) { [weak self] _ in
            guard let self else { return }
            libraryViewModel.changeStatus(key: book.key, status: .wantToRead)
        }
        let reading = UIAlertAction(title: book.status == .reading ? "Reading (Current)" : "Reading", style: .default) { [weak self] _ in
            guard let self else { return }
            libraryViewModel.changeStatus(key: book.key, status: .reading)
        }
        let completed = UIAlertAction(title: book.status == .completed ? "Completed (Current)" : "Completed", style: .default) { [weak self] _ in
            guard let self else { return }
            libraryViewModel.changeStatus(key: book.key, status: .completed)
        }
        wantToRead.isEnabled = book.status != .wantToRead
        reading.isEnabled = book.status != .reading
        completed.isEnabled = book.status != .completed
        
        alert.addAction(wantToRead)
        alert.addAction(reading)
        alert.addAction(completed)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = tableView
            popover.sourceRect = tableView.rectForRow(at: indexPath)
        }
        present(alert, animated: true)
    }
    
    private func getBookIndexAt(key: String) -> Int? {
        libraryViewModel.getBookIndexAtKey(key)
    }
    
    private func bindViewModel() {
        libraryViewModel.onStateChanged = { [weak self] state in
            self?.handleState(state: state)
        }
    }
    
    private func handleState(state: SavedBookState) {
        switch state {
        case .loaded:
            setEmptyStateVisible(libraryViewModel.displayedBooks.isEmpty)
            tableView.reloadData()
        case .changed(key: let key):
            guard let index = getBookIndexAt(key: key) else { return }
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        case .error(let message):
            showErrorAlert(message: message)
        }
    }
    
    private func setEmptyStateVisible(_ isVisible: Bool) {
        if !isVisible {
            tableView.backgroundView?.isHidden = true
        } else {
            tableView.backgroundView?.isHidden = false
        }
    }
}

extension LibraryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        libraryViewModel.displayedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedBookCell.reuseIdentifier, for: indexPath)
                as? SavedBookCell
        else {
            return UITableViewCell()
        }
        let currentBook = libraryViewModel.displayedBooks[indexPath.row]
        cell.configure(with: currentBook, imageLoader: imageLoader)
        return cell
    }
}

extension LibraryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentKey = libraryViewModel.displayedBooks[indexPath.row].key
        onBookSelected?(currentKey)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentBook = libraryViewModel.displayedBooks[indexPath.row]
        let currentBookKey = currentBook.key
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let self else {
                completionHandler(false)
                return
            }
            let deleted = libraryViewModel.deleteBook(key: currentBookKey)
            completionHandler(deleted)
        }
        let statusAction = UIContextualAction(style: .normal, title: "Change status") { [weak self] _, _, completionHandler in
            guard let self else {
                completionHandler(false)
                return
            }
            showStatusSelection(book: currentBook, indexPath: indexPath)
            completionHandler(true)
        }
        statusAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [statusAction, deleteAction])
    }
}
