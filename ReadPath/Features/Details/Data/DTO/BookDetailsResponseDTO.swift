//
//  BookDetailsDTO.swift
//  ReadPath
//
//  Created by Егор on 02.10.2026.
//

struct BookDetailsResponseDTO: Decodable {
    let title: String
    let key: String
    let description: DescriptionDTO?
    let covers: [Int]?
    let subjects: [String]?
}

enum DescriptionDTO: Decodable {
    case text(String)
    
    var value: String {
        switch self {
        case .text(let text):
            return text
        }
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let text = try? container.decode(String.self) {
            self = .text(text)
            return
        }
        
        let object = try container.decode(DescriptionObjectDTO.self)
        self = .text(object.value)
    }
}

struct DescriptionObjectDTO: Decodable {
    let value: String
}
   
     
