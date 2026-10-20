//
//  DetailsState.swift
//  ReadPath
//
//  Created by Егор on 02.10.2026.
//

import Foundation

enum DetailsState: Equatable {
    case loading
    case loaded(BookDetails)
    case error(String)
}
