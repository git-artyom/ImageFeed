//
//  OAuthService.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 02.08.2023.
//

import Foundation


final class OAuthService {
    
    private let urlSession = URLSession.shared
    private var authToken: String? {
        get {
            return OAuthTokenStorage().token
        }
        set {
            OAuthTokenStorage().token = newValue
        }
    }
    
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let request = requestAuthToken(code: code)
        let task = data(for: request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                assertionFailure("no token")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}


extension OAuthService {
    
    // запрос и обработка данных с сервера
    func data(for request: URLRequest, complition: @escaping (Result<OAuthTokenResponseBody,Error>) -> Void) -> URLSessionTask {
        
        let decoder = JSONDecoder()
        return urlSession.data(for: request ) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result {
                    try decoder.decode(OAuthTokenResponseBody.self, from: data)
                }
            }
            complition(response)
        }
    }
    
}


// создаем запрос к usplash по схеме Authorization workflow
extension OAuthService {
    
    func requestAuthToken(code: String) -> URLRequest {
        URLRequest.makeHttpRequest(
            path: "/oauth/token"
            + "?client_id=\(accessKey)"
            + "&&client_secret=\(secretKey)"
            + "&&redirect_uri=\(redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
    
    
}
