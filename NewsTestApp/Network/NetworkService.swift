//
//  NetworkService.swift
//  NewsTestApp
//
//  Created by shizo663 on 26.02.2021.
//

import Foundation


class NetworkService {

    func request(url: URL?, completion: @escaping (Data?, Error?) -> Void) {
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) { (data, responce, error) in
                if let responce = responce {
                    //
                }
                if let data = data {
                    completion(data,error)
                }
                
                if let error = error {
                    print(error)
                }
            }
            task.resume()
        }
    }
}
