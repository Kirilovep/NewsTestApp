//
//  NetworkDataFetcher.swift
//  NewsTestApp
//
//  Created by shizo663 on 26.02.2021.
//

import Foundation

protocol DataFetcher {
    func fetchData<T: Codable>(url: URL?, _ responce: @escaping (T?) -> Void)
}

class NetworkDataFetcher: DataFetcher {
    
    var network: NetworkService?
    
    init(network: NetworkService = NetworkService()) {
        self.network = network
    }
    
    func fetchData<T: Codable>(url: URL?, _ responce: @escaping (T?) -> Void) {
        
        network?.request(url: url, completion: { (data, error) in
            if let error = error {
                print("\(error)")
                responce(nil)
            }
            if let data = data {
                let decoder = JSONDecoder()
                let objects = try? decoder.decode(T.self, from: data)
                responce(objects)
            }
            
            
        })
    }
}
