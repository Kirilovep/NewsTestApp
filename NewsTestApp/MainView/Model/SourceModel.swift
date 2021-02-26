//
//  SourceModel.swift
//  NewsTestApp
//
//  Created by shizo663 on 26.02.2021.
//

import Foundation


struct SourceModel: Codable {
    let status: String?
    let sources: [Sources]?
}

// MARK: - Source
struct Sources: Codable {
    let id, name: String?
    let description: String?
    let url: String?
    let category: String?
    let language, country: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case description
        case url, category, language, country
    }
}

enum Category: String, Codable {
    case business = "business"
    case entertainment = "entertainment"
    case general = "general"
    case health = "health"
    case science = "science"
    case sports = "sports"
    case technology = "technology"
}
