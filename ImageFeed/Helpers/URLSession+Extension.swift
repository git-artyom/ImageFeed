//
//  URLSession+Extension.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 02.08.2023.
//

import Foundation


enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

// создаем сессию
extension URLSession {
    
    func data(for request: URLRequest, complition: @escaping (Result<Data,Error>) -> Void) -> URLSessionTask {
        let fulfillCompleteon: (Result<Data,Error>) -> Void = { result in
            DispatchQueue.main.async {
                complition(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    print(String(data: data, encoding: .utf8)!)
                    fulfillCompleteon(.success(data))
                } else {
                    fulfillCompleteon(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompleteon(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompleteon(.failure(NetworkError.urlSessionError))
            }
        }
        
        task.resume()
        return task
    }
}

extension URLSession {
    
    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return data(for: request) { (result: Result<Data,Error>) in
            let response = result.flatMap { data -> Result<T, Error> in
                Result {
                    try decoder.decode(T.self, from: data)
                }
            }
            completion(response)
        }
    }
    
}
