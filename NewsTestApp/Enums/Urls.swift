//
//  Urls.swift
//  NewsTestApp
//
//  Created by shizo663 on 26.02.2021.
//

import Foundation


enum Urls: String {
    case baseTopHeadlinesUrl = "https://newsapi.org/v2/top-headlines?"
    case country = "country="
    case category = "&category="
    case page = "&page="
    case apiKey = "&apiKey=9324e6b3ab9945f68b4b463b0202dc93"
    
    case baseSearchEverything = "https://newsapi.org/v2/everything?q="
}
