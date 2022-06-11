//
//  NetworkManager.swift
//  AudioNetwork
//
//  Created by OlegPrushlyak on 27.07.2021.
//

import Foundation

class NetworkManager {
    func getAllPosts( urlString: String, complitionHandler: @escaping (Result<SearchResponse, Error>) -> Void){
        if let url = URL(string: urlString ) {
            URLSession.shared.dataTask(with: url) { (data, responsse, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("error in request")
                        complitionHandler(.failure(error))
                        return
                    }
                    guard let responseData = data else { return }
                    do{
                        let posts = try JSONDecoder().decode(SearchResponse.self, from: responseData)
                        complitionHandler(.success(posts))

                    } catch let error {
                        print("error", error)
                        complitionHandler(.failure(error))
                    }
                }
            }.resume()
        }
    }
}
