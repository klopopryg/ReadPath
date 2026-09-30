//
//  DiscoverState.swift
//  ReadPath
//
//  Created by Егор on 28.09.2026.
//

enum DiscoverState {
    case idle
    case loading
    case loaded
    case empty(String)
    case loadingMore
    case error(String)
}
