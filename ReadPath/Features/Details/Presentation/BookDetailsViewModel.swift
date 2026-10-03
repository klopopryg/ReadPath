//
//  BookDetailsViewModel.swift
//  ReadPath
//
//  Created by Егор on 02.10.2026.
//

import Foundation

final class BookDetailsViewModel {
    private let repository: BookDetailsRepositoryProtocol
    private let key: String
    var onStateChanged: ((DetailsState) -> Void)?
    
    init(repository: BookDetailsRepositoryProtocol, key: String) {
        self.repository = repository
        self.key = key
    }
    
    func loadDetails() {
        onStateChanged?(.loading)
        Task {
            do {
                let details = try await repository.loadDetails(key: key)
                onStateChanged?(.loaded(details))
            } catch {
                onStateChanged?(.error(error.localizedDescription))
            }
        }
    }
    
}
