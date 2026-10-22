//
//  DiscoverViewModelTests.swift
//  ReadPath
//
//  Created by Егор on 20.10.2026.
//

import Testing
@testable import ReadPath
import Foundation

@MainActor
final class DiscoverViewModelTests {
    
    @Test func searchLoadsBooksAndSendsLoadedState() async {
        let booksPage = BooksPage(
            books: [Book(
                authorName: nil,
                firstPublishYear: nil,
                coverURL: nil,
                key: "key",
                title: "book"
            )],
            total: 10
        )
        
        let fakeBooksRepository = FakeBooksRepository(pages: [1: booksPage])
        let discoverViewModel = DiscoverViewModel(booksRepository: fakeBooksRepository)
        var states: [DiscoverState] = []
        await withCheckedContinuation { continuation in
            discoverViewModel.onStateChanged = { state in
                states.append(state)
                
                switch state {
                case .loadingError, .loaded, .empty:
                    continuation.resume()
                default:
                    break
                }
            }
            discoverViewModel.search(query: "query")
        }
        #expect(states == [.loading, .loaded])
        #expect(discoverViewModel.books == booksPage.books)
    }
    
    @Test func searchSendsEmptyStateWhenNoBooksFound() async {
        let booksPage = BooksPage(books: [], total: 0)
        let fakeBooksRepository = FakeBooksRepository(pages: [1: booksPage])
        let discoverViewModel = DiscoverViewModel(booksRepository: fakeBooksRepository)
        var states: [DiscoverState] = []
        await withCheckedContinuation { continuation in
            discoverViewModel.onStateChanged = { state in
                states.append(state)
                
                switch state {
                case .loadingError, .loaded, .empty:
                    continuation.resume()
                default:
                    break
                }
            }
            discoverViewModel.search(query: "query")
        }
        #expect(states == [.loading, .empty("query")])
        #expect(discoverViewModel.books.isEmpty)
    }
    
    @Test func searchSendsLoadingErrorWhenRepositoryFails() async {
        let fakeBooksRepository = FakeBooksRepository(pages: [:])
        let discoverViewModel = DiscoverViewModel(booksRepository: fakeBooksRepository)
        var states: [DiscoverState] = []
        await withCheckedContinuation { continuation in
            discoverViewModel.onStateChanged = { state in
                states.append(state)
                
                switch state {
                case .loadingError, .loaded, .empty:
                    continuation.resume()
                default:
                    break
                }
            }
            discoverViewModel.search(query: "query")
        }
        #expect(states == [.loading, .loadingError(TestError.loadingFailed.localizedDescription)])
        #expect(discoverViewModel.books.isEmpty)
    }
    
    @Test func loadNextPageAppendsBooksAndSendsInsertedRange() async {
        let firstBook = Book(
            authorName: nil,
            firstPublishYear: nil,
            coverURL: nil,
            key: "firstKey",
            title: "firstBook"
        )
        let secondBook = Book(
            authorName: nil,
            firstPublishYear: nil,
            coverURL: nil,
            key: "secondKey",
            title: "secondBook"
        )
        let firstBooksPage = BooksPage(books: [firstBook], total: 10)
        let secondBooksPage = BooksPage(books: [secondBook], total: 10)
        let fakeBooksRepository = FakeBooksRepository(
            pages: [1: firstBooksPage, 2: secondBooksPage]
        )
        let discoverViewModel = DiscoverViewModel(booksRepository: fakeBooksRepository)
        
        await withCheckedContinuation { continuation in
            discoverViewModel.onStateChanged = { state in
                switch state {
                case .loaded, .empty, .loadingError:
                    continuation.resume()
                default:
                    break
                }
            }
            discoverViewModel.search(query: "query")
        }
        #expect(discoverViewModel.books == [firstBook])
        
        var states: [DiscoverState] = []
        await withCheckedContinuation { continuation in
            discoverViewModel.onStateChanged = { state in
                states.append(state)
                
                switch state {
                case .loadedNextPage, .loadingError:
                    continuation.resume()
                default:
                    break
                }
            }
            discoverViewModel.loadNextPage()
        }
        #expect(discoverViewModel.books == [firstBook, secondBook])
        #expect(states == [.loadingMore, .loadedNextPage(1..<2)])
    }
    
    @Test func loadNextPagePreservesBooksAndRetriesSamePageAfterFailure() async {
        let firstBook = Book(
            authorName: nil,
            firstPublishYear: nil,
            coverURL: nil,
            key: "firstKey",
            title: "firstBook"
        )
        let firstBooksPage = BooksPage(books: [firstBook], total: 10)
        let fakeBooksRepository = FakeBooksRepository(
            pages: [1: firstBooksPage]
        )
        let discoverViewModel = DiscoverViewModel(booksRepository: fakeBooksRepository)
        
        await withCheckedContinuation { continuation in
            discoverViewModel.onStateChanged = { state in
                switch state {
                case .loaded, .empty, .loadingError:
                    continuation.resume()
                default:
                    break
                }
            }
            discoverViewModel.search(query: "query")
        }
        #expect(discoverViewModel.books == [firstBook])
        
        var states: [DiscoverState] = []
        await withCheckedContinuation { continuation in
            discoverViewModel.onStateChanged = { state in
                states.append(state)
                
                switch state {
                case .loadedNextPage, .nextPageError:
                    continuation.resume()
                default:
                    break
                }
            }
            discoverViewModel.loadNextPage()
        }
        #expect(discoverViewModel.books == [firstBook])
        #expect(states == [
            .loadingMore,
            .nextPageError(TestError.loadingFailed.localizedDescription)
        ])
        
        await withCheckedContinuation { continuation in
            discoverViewModel.onStateChanged = { state in
                
                switch state {
                case .loadedNextPage, .nextPageError:
                    continuation.resume()
                default:
                    break
                }
            }
            discoverViewModel.loadNextPage()
        }
        #expect(fakeBooksRepository.requestedPages == [1, 2, 2])
        #expect(discoverViewModel.books == [firstBook])
    }
    
    @Test func loadNextPageDoesNotRequestWhenAllBooksAreLoaded() async {
        let firstBook = Book(
            authorName: nil,
            firstPublishYear: nil,
            coverURL: nil,
            key: "firstKey",
            title: "firstBook")
        let firstPage = BooksPage(books: [firstBook], total: 1)
        let fakeBooksRepository = FakeBooksRepository(pages: [1: firstPage])
        let discoverViewModel = DiscoverViewModel(booksRepository: fakeBooksRepository)
        await withCheckedContinuation { continuation in
            discoverViewModel.onStateChanged = { state in
                switch state {
                case .loaded, .empty, .loadingError:
                    continuation.resume()
                default:
                    break
                }
            }
            discoverViewModel.search(query: "query")
        }
        #expect(fakeBooksRepository.requestedPages == [1])
        
        var states: [DiscoverState] = []
        discoverViewModel.onStateChanged = { state in
            states.append(state)
        }
        discoverViewModel.loadNextPage()
        
        #expect(states.isEmpty)
        await Task.yield()
        #expect(fakeBooksRepository.requestedPages == [1])
    }
    
    @Test func loadNextPageDoesNotStartAnotherRequestWhileLoading() async {
        let firstBook = Book(
            authorName: nil,
            firstPublishYear: nil,
            coverURL: nil,
            key: "firstKey",
            title: "firstBook"
        )
        let secondBook = Book(
            authorName: nil,
            firstPublishYear: nil,
            coverURL: nil,
            key: "secondKey",
            title: "secondBook"
        )
        let firstBooksPage = BooksPage(books: [firstBook], total: 2)
        let secondBooksPage = BooksPage(books: [secondBook], total: 2)
        let fakeBooksRepository = FakeBooksRepository(
            pages: [1: firstBooksPage, 2: secondBooksPage]
        )
        fakeBooksRepository.pageToSuspend = 2
        let discoverViewModel = DiscoverViewModel(booksRepository: fakeBooksRepository)
        
        await withCheckedContinuation { continuation in
            discoverViewModel.onStateChanged = { state in
                switch state {
                case .loaded, .empty, .loadingError:
                    continuation.resume()
                default:
                    break
                }
            }
            discoverViewModel.search(query: "query")
        }
        discoverViewModel.onStateChanged = nil
        await withCheckedContinuation { continuation in
            fakeBooksRepository.onRequestSuspended = {
                continuation.resume()
            }
            
            discoverViewModel.loadNextPage()
        }
        fakeBooksRepository.onRequestSuspended = nil
        discoverViewModel.loadNextPage()
        #expect(fakeBooksRepository.requestedPages == [1, 2])
        
        await withCheckedContinuation { continuation in
            discoverViewModel.onStateChanged = { state in
                switch state {
                case .loadedNextPage, .nextPageError:
                    continuation.resume()
                default:
                    break
                }
            }
            fakeBooksRepository.completePendingRequestWithPage(secondBooksPage)
        }
        #expect(discoverViewModel.books == [firstBook, secondBook])
        #expect(fakeBooksRepository.requestedPages == [1, 2])
    }
    
    @Test func searchIgnoresOldResponseAfterNewSearch() async {
        let oldBook = Book(
            authorName: nil,
            firstPublishYear: nil,
            coverURL: nil,
            key: "firstKey",
            title: "firstBook"
        )
        let newBook = Book(
            authorName: nil,
            firstPublishYear: nil,
            coverURL: nil,
            key: "secondKey",
            title: "secondBook"
        )
        let oldPage = BooksPage(books: [oldBook], total: 2)
        let newPage = BooksPage(books: [newBook], total: 2)
        let fakeBooksRepository = FakeBooksRepository(pages: [1: newPage])
        fakeBooksRepository.pageToSuspend = 1
        fakeBooksRepository.queryToSuspend = "old"
        let discoverViewModel = DiscoverViewModel(booksRepository: fakeBooksRepository)
        
        var oldSearchTask: Task<Void, Never>?
        await withCheckedContinuation { continuation in
            fakeBooksRepository.onRequestSuspended = {
                continuation.resume()
            }
            oldSearchTask = discoverViewModel.search(query: "old")
        }
        fakeBooksRepository.onRequestSuspended = nil
        
        await withCheckedContinuation { continuation in
            discoverViewModel.onStateChanged = { state in
                switch state {
                case .loaded, .loadingError, .empty:
                    continuation.resume()
                default:
                    break
                }
            }
            discoverViewModel.search(query: "new")
        }
        discoverViewModel.onStateChanged = nil
        #expect(discoverViewModel.books == [newBook])
        
        fakeBooksRepository.completePendingRequestWithPage(oldPage)
        await oldSearchTask?.value
        #expect(discoverViewModel.books == [newBook])
    }
}
