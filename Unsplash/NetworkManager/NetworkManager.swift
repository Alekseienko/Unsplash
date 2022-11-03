//
//  NetworkManager.swift
//  Unsplash
//
//  Created by alekseienko on 30.10.2022.
//

import Foundation

class NetworkManager {
    private init() {}
    
    static let shared: NetworkManager = NetworkManager()
    
    func getData(searchText: String?, resault: @escaping ((UnsplashModel?) -> ())) {
    
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/search/photos"
        let page = URLQueryItem(name: "page", value: "1")
        let query = URLQueryItem(name: "query", value: searchText)
        let perPage = URLQueryItem(name: "per_page", value: "30")
        let clienID = URLQueryItem(name: "client_id", value: "WPsXpDIPqmiqieL-92RodRpCVe94WEkXXd65kPoqaYM")
        
        urlComponents.queryItems = [ page, query, perPage, clienID]
        
        guard let url = urlComponents.url else {
            print("Some problem with URL")
            return
        }
        
        var request = URLRequest(url: url)
        print(url)
        request.httpMethod = "GET"
        let task = URLSession(configuration: .default)
        task.dataTask(with: request) { data, response, error in
            if error == nil {
                do {
                    let decoderModel = try JSONDecoder().decode(UnsplashModel.self, from: data!)
                    resault(decoderModel)
                } catch let jsonError {
                    print("Failde to decode JSON", jsonError)
                }
            } else {
                print("Some problem with data")
            }
        }.resume()
    }
}
