//
//  ReadPathTests.swift
//  ReadPathTests
//
//  Created by Егор on 27.09.2026.
//

import Foundation
import Testing
@testable import ReadPath

struct StatisticsViewModelTests {

    @Test func refreshStatisticsUpdatesCountsForEachReadingStatus() {
        let fakeLibraryStore = FakeLibraryStore()
        let wantToRead = makeBook(key: "wantToRead", status: .wantToRead)
        let readingFirst = makeBook(key: "reading", status: .reading)
        let readingSecond = makeBook(key: "reading", status: .reading)
        let completed = makeBook(key: "completed", status: .completed)
        fakeLibraryStore.savedBooks = [wantToRead, readingFirst, readingSecond, completed]
        let viewModel = StatisticsViewModel(libraryStore: fakeLibraryStore)
        viewModel.refreshStatistics()
        #expect(viewModel.totalBooksCount == 4)
        #expect(viewModel.wantToReadBooksCount == 1)
        #expect(viewModel.readingBooksCount == 2)
        #expect(viewModel.completedBooksCount == 1)
    }
    
    @Test func refreshStatisticsSetsAllCountsToZeroWhenLibraryIsEmpty() {
        let fakeLibraryStore = FakeLibraryStore()
        let viewModel = StatisticsViewModel(libraryStore: fakeLibraryStore)
        viewModel.refreshStatistics()
        #expect(viewModel.totalBooksCount == 0)
        #expect(viewModel.wantToReadBooksCount == 0)
        #expect(viewModel.readingBooksCount == 0)
        #expect(viewModel.completedBooksCount == 0)
    }
    
    @Test func refreshStatisticsSetsErrorMessageWhenStoreFails() {
        let fakeLibraryStore = FakeLibraryStore()
        fakeLibraryStore.error = .loadingFailed
        let viewModel = StatisticsViewModel(libraryStore: fakeLibraryStore)
        viewModel.refreshStatistics()
        let error: TestError = .loadingFailed
        let expectedErrorMessage = error.localizedDescription
        #expect(viewModel.errorMessage == expectedErrorMessage)
    }
    
    @Test func refreshStatisticsRecalculatesCountsWhenBooksChange() {
        let fakeLibraryStore = FakeLibraryStore()
        let wantToRead = makeBook(key: "wantToRead", status: .wantToRead)
        let readingFirst = makeBook(key: "reading", status: .reading)
        let readingSecond = makeBook(key: "reading", status: .reading)
        let completed = makeBook(key: "completed", status: .completed)
        fakeLibraryStore.savedBooks = [wantToRead, readingFirst, readingSecond, completed]
        let viewModel = StatisticsViewModel(libraryStore: fakeLibraryStore)
        viewModel.refreshStatistics()
        #expect(viewModel.totalBooksCount == 4)
        #expect(viewModel.wantToReadBooksCount == 1)
        fakeLibraryStore.savedBooks.removeFirst()
        viewModel.refreshStatistics()
        #expect(viewModel.totalBooksCount == 3)
        #expect(viewModel.wantToReadBooksCount == 0)
        #expect(viewModel.readingBooksCount == 2)
        #expect(viewModel.completedBooksCount == 1)
    }
    
    @Test func refreshStatisticsClearsErrorMessageAfterSuccessfulRetry() {
        let fakeLibraryStore = FakeLibraryStore()
        fakeLibraryStore.error = .loadingFailed
        let viewModel = StatisticsViewModel(libraryStore: fakeLibraryStore)
        viewModel.refreshStatistics()
        let error: TestError = .loadingFailed
        let expectedErrorMessage = error.localizedDescription
        #expect(viewModel.errorMessage == expectedErrorMessage)
        fakeLibraryStore.error = nil
        viewModel.refreshStatistics()
        #expect(viewModel.errorMessage == nil)
    }
}
