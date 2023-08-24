//
//  PresenterBooks.swift
//  GoogleBooks
//
//  Created by Osvaldo Arriaga Garduño on 23/08/23.
//

import Foundation


extension URLSession {
    
    static let apiKey = "AIzaSyBB1V9jE8u-mBZELDCdDbVRQDjdZluEJD8"

    static func fetchBooks(withQuery query: String, completion: @escaping (Result<ModelBooks, Error>) -> Void) {
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(query)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ModelBooks.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
