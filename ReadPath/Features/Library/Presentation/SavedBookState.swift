//
//  SavedBookState.swift
//  ReadPath
//
//  Created by Егор on 09.10.2026.
//

enum SavedBookState: Equatable {
    case loaded
    case changed(key: String)
    case error(String)
}
