//
//  BookDetailsViewModel.swift
//  ReadPath
//
//  Created by Егор on 20.10.2026.
//

import Testing
@testable import ReadPath
import Foundation

@MainActor
final class BookDetailsViewModelTests {
    @Test func loadDetailsSendsLoadingAndLoadedStates() async {
        let fakeLibraryStore = FakeLibraryStore()
        let bookDetails = BookDetails(
            title: "book",
            id: "1",
            description: nil,
            coverID: nil,
            coverURL: nil,
            subjects: nil
        )
        let fakeBookDetailsRepository = FakeBookDetailsRepository(bookDetails: bookDetails)
        let bookDetailsViewModel = BookDetailsViewModel(
            repository: fakeBookDetailsRepository,
            key: bookDetails.id,
            libraryStore: fakeLibraryStore
        )
        var states: [DetailsState] = []
        let expectedStates: [DetailsState] = [.loading, .loaded(bookDetails)]
        await withCheckedContinuation { continuation in
            bookDetailsViewModel.onStateChanged = { state in
                states.append(state)
                
                switch state {
                case .loaded, .error:
                    continuation.resume()
                case .loading:
                    break
                }
            }
            bookDetailsViewModel.loadDetails()
        }
        #expect(states == expectedStates)
    }
    
    @Test func loadDetailsSendsLoadingAndErrorStateWhenRepositoryFails() async {
        let fakeLibraryStore = FakeLibraryStore()
        let fakeBookDetailsRepository = FakeBookDetailsRepository(bookDetails: nil)
        let bookDetailsViewModel = BookDetailsViewModel(
            repository: fakeBookDetailsRepository,
            key: "key",
            libraryStore: fakeLibraryStore
        )
        var states: [DetailsState] = []
        let expectedStates: [DetailsState] = [.loading, .error(TestError.loadingFailed.localizedDescription)]
        await withCheckedContinuation { continuation in
            bookDetailsViewModel.onStateChanged = { state in
                states.append(state)
                switch state {
                case .loaded, .error:
                    continuation.resume()
                case .loading:
                    break
                }
            }
            bookDetailsViewModel.loadDetails()
        }
        #expect(states == expectedStates)
    }
    
    @Test func loadDetailsReportsBookIsInLibraryWhenAlreadySaved() async {
        let fakeLibraryStore = FakeLibraryStore()
        let savedBook = SavedBook(
            key: "key",
            title: "book",
            coverID: nil,
            status: .wantToRead,
            addedAt: Date()
        )
        fakeLibraryStore.savedBooks = [savedBook]
        let bookDetails = BookDetails(
            title: "book",
            id: "key",
            description: nil,
            coverID: nil,
            coverURL: nil,
            subjects: nil
        )
        let fakeBookDetailsRepository = FakeBookDetailsRepository(bookDetails: bookDetails)
        let bookDetailsViewModel = BookDetailsViewModel(
            repository: fakeBookDetailsRepository,
            key: "key",
            libraryStore: fakeLibraryStore
        )
        var results: [LibraryActionResult] = []
        await withCheckedContinuation { continuation in
            bookDetailsViewModel.onLibraryAction = { result in
                results.append(result)
                continuation.resume()
            }
            bookDetailsViewModel.loadDetails()
        }
        #expect(results == [.memberShipChanged(isInLibrary: true)])
    }
    
    @Test func loadDetailsReportsBookIsNotInLibraryWhenNotSaved() async {
        let fakeLibraryStore = FakeLibraryStore()
        let bookDetails = BookDetails(
            title: "book",
            id: "key",
            description: nil,
            coverID: nil,
            coverURL: nil,
            subjects: nil
        )
        let fakeBookDetailsRepository = FakeBookDetailsRepository(bookDetails: bookDetails)
        let bookDetailsViewModel = BookDetailsViewModel(
            repository: fakeBookDetailsRepository,
            key: "key",
            libraryStore: fakeLibraryStore
        )
        var results: [LibraryActionResult] = []
        await withCheckedContinuation { continuation in
            bookDetailsViewModel.onLibraryAction = { result in
                results.append(result)
                continuation.resume()
            }
            bookDetailsViewModel.loadDetails()
        }
        #expect(results == [.memberShipChanged(isInLibrary: false)])
    }
    
    @Test func toggleLibraryMembershipAddsBookWhenNotSaved() async {
        let fakeLibraryStore = FakeLibraryStore()
        let bookDetails = BookDetails(
            title: "book",
            id: "key",
            description: nil,
            coverID: 123,
            coverURL: nil,
            subjects: nil
        )
        let fakeBookDetailsRepository = FakeBookDetailsRepository(bookDetails: bookDetails)
        let bookDetailsViewModel = BookDetailsViewModel(
            repository: fakeBookDetailsRepository,
            key: bookDetails.id,
            libraryStore: fakeLibraryStore)
        await withCheckedContinuation { continuation in
            bookDetailsViewModel.onLibraryAction = { _ in
                continuation.resume()
            }
            bookDetailsViewModel.loadDetails()
        }
        var results: [LibraryActionResult] = []
        bookDetailsViewModel.onLibraryAction = { result in
            results.append(result)
        }
        bookDetailsViewModel.toggleLibraryMemberShip()
        #expect(fakeLibraryStore.savedBooks.count == 1)
        #expect(fakeLibraryStore.savedBooks.first?.key == bookDetails.id)
        #expect(fakeLibraryStore.savedBooks.first?.title == bookDetails.title)
        #expect(fakeLibraryStore.savedBooks.first?.coverID == 123)
        #expect(fakeLibraryStore.savedBooks.first?.status == .wantToRead)
        
        #expect(results == [.memberShipChanged(isInLibrary: true)])
    }
    
    @Test func toggleLibraryMembershipRemovesBookWhenAlreadySaved() {
        let fakeLibraryStore = FakeLibraryStore()
        let savedBook = SavedBook(
            key: "key",
            title: "book",
            coverID: nil,
            status: .wantToRead,
            addedAt: Date()
            )
        fakeLibraryStore.savedBooks = [savedBook]
        let fakeBookDetailsRepository = FakeBookDetailsRepository(bookDetails: nil)
        let bookDetailsViewModel = BookDetailsViewModel(
            repository: fakeBookDetailsRepository,
            key: savedBook.key,
            libraryStore: fakeLibraryStore)
        var results: [LibraryActionResult] = []
        bookDetailsViewModel.onLibraryAction = { result in
            results.append(result)
        }
        bookDetailsViewModel.toggleLibraryMemberShip()
        #expect(fakeLibraryStore.savedBooks.isEmpty)
        #expect(results == [.memberShipChanged(isInLibrary: false)])
    }
    
    @Test func toggleLibraryMembershipSendsErrorWhenDeletionFails() {
        let fakeLibraryStore = FakeLibraryStore()
        let savedBook = SavedBook(
            key: "key",
            title: "book",
            coverID: nil,
            status: .wantToRead,
            addedAt: Date()
            )
        fakeLibraryStore.savedBooks = [savedBook]
        fakeLibraryStore.error = .deletionFailed
        let fakeBookDetailsRepository = FakeBookDetailsRepository(bookDetails: nil)
        let bookDetailsViewModel = BookDetailsViewModel(
            repository: fakeBookDetailsRepository,
            key: savedBook.key,
            libraryStore: fakeLibraryStore)
        var results: [LibraryActionResult] = []
        bookDetailsViewModel.onLibraryAction = { result in
            results.append(result)
        }
        bookDetailsViewModel.toggleLibraryMemberShip()
        #expect(fakeLibraryStore.savedBooks == [savedBook])
        #expect(results == [.error(TestError.deletionFailed.localizedDescription)])
    }
    
    @Test func toggleLibraryMembershipSendsErrorWhenSavingFails() async {
        let fakeLibraryStore = FakeLibraryStore()
        let bookDetails = BookDetails(
            title: "book",
            id: "key",
            description: nil,
            coverID: nil,
            coverURL: nil,
            subjects: nil)
        let fakeBookDetailsRepository = FakeBookDetailsRepository(bookDetails: bookDetails)
        let bookDetailsViewModel = BookDetailsViewModel(
            repository: fakeBookDetailsRepository,
            key: "key",
            libraryStore: fakeLibraryStore)
        await withCheckedContinuation { continuation in
            bookDetailsViewModel.onLibraryAction = { _ in
                continuation.resume()
            }
            bookDetailsViewModel.loadDetails()
        }
        var results: [LibraryActionResult] = []
        bookDetailsViewModel.onLibraryAction = { result in
            results.append(result)
        }
        fakeLibraryStore.error = .savingFailed
        bookDetailsViewModel.toggleLibraryMemberShip()
        #expect(fakeLibraryStore.savedBooks.isEmpty)
        #expect(results == [.error(TestError.savingFailed.localizedDescription)])
    }
}
