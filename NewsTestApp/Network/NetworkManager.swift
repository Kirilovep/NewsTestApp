//
//  NetworkManager.swift
//  NewsTestApp
//
//  Created by shizo663 on 25.02.2021.
//

import Foundation


class NetworkManager {
    
    
    var networkDataFetcher: DataFetcher?
    
    init(networkDataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.networkDataFetcher = networkDataFetcher
    }
    
    
    func fetchData(_ page: Int,_ country: String,_ category: String,_ completionHandler: @escaping (NewsModel?) -> Void) {
        if let url = URL(string: "\(Urls.baseTopHeadlinesUrl.rawValue)\(Urls.country.rawValue)\(country)\(Urls.category.rawValue)\(category)\(Urls.page.rawValue)\(page)\(Urls.apiKey.rawValue)") {
            networkDataFetcher?.fetchData(url: url, completionHandler)
        }
    }
    
    func searchNews(_ page: Int,_ quary: String,_ completionHandler: @escaping (NewsModel?) -> Void) {
        if let url = URL(string: "\(Urls.baseSearchEverything.rawValue)\(quary)\(Urls.page.rawValue)\(page)\(Urls.apiKey.rawValue)") {
            networkDataFetcher?.fetchData(url: url, completionHandler)
        }
    }
    
    func fetchSources(_ completionHandler: @escaping (SourceModel?) -> Void) {
        if let url = URL(string: "https://newsapi.org/v2/sources?apiKey=3669eabc6d4a45a78fe1a133d8296bf6") {
            networkDataFetcher?.fetchData(url: url, completionHandler)
        }
    }

    
}

