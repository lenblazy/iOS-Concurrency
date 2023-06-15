//
//  ApiService.swift
//  iOS Concurrency
//
//  Created by Lennox Mwabonje on 15/06/2023.
//

import Foundation


struct ApiService{
    
    let urlString: String
    
    func getJSON<T: Decodable>(
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        completion: @escaping (Result<T, APIError>) -> Void){
            guard let url = URL(string: urlString) else {
                completion(.failure(.invalidURL))
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
                else {
                    completion(.failure(.invalidResponseStatus))
                    return
                }
                
                guard error == nil
                else{
                    completion(.failure(.dataTaskError))
                    return
                }
                
                guard
                    let data = data
                else {
                    completion(.failure(.corruptData))
                    return
                }
                
                let decoder = JSONDecoder()
                
                do{
                    let decodedData = try decoder.decode(T.self, from: data)
                    completion(.success(decodedData))
                }catch{
                    completion(.failure(.decodingError))
                }
                
                
                
            }.resume()
        }
    
}

enum APIError: Error{
    case invalidURL
    case invalidResponseStatus
    case dataTaskError
    case corruptData
    case decodingError
}
