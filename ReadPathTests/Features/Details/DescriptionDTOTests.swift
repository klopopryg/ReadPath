//
//  DescriptionDTOTests.swift
//  ReadPath
//
//  Created by Егор on 18.10.2026.
//

import Testing
@testable import ReadPath
import Foundation

@MainActor
final class DescriptionDTOTests {
    
    @Test func decodesDescriptionFromString() throws {
        let json = """
            "Book description"
            """
        
        let data = Data(json.utf8)
        
        let description = try JSONDecoder().decode(
            DescriptionDTO.self, from: data
        )
        
        #expect(description.value == "Book description")
    }
    
    @Test func decodeDescriptionFromObject() throws {
        let json = """
            {
            "type": "/type/text",
            "value": "Description from object"
            }
            """
        
        let data = Data(json.utf8)
        
        let description = try JSONDecoder().decode(
            DescriptionDTO.self, from: data
        )
        
        #expect(description.value == "Description from object")
    }
}
