//
//  LibraryActionResult.swift
//  ReadPath
//
//  Created by Егор on 08.10.2026.
//

enum LibraryActionResult: Equatable {
    case memberShipChanged(isInLibrary: Bool)
    case error(String)
}
