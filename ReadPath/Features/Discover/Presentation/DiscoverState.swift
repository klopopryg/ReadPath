//
//  DiscoverState.swift
//  ReadPath
//
//  Created by Егор on 28.09.2026.
//

enum DiscoverState: Equatable {
    case idle
    case loading
    case loaded
    case empty(String)
    case loadingMore
    case loadingError(String)
    case nextPageError(String)
    case loadedNextPage(Range<Int>)
}
