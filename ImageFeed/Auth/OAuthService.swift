//
//  OAuthService.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 02.08.2023.
//

import Foundation


final class OAuthService {
    
    static let shared = OAuthService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask? // Переменная для хранения указателя на последнюю созданную задачу
    private var lastCode: String? // Переменная для хранения значения code, которое было передано в последнем созданном запросе
    private var authToken: String? {
        get {
            return OAuthTokenStorage().token
        }
        set {
            OAuthTokenStorage().token = newValue
        }
    }
        
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        guard let request = requestAuthToken(code: code) else {
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    completion(.success(authToken))
                    self.task = nil
                case .failure(let error):
                    assertionFailure("no token")
                    completion(.failure(error))
                    self.lastCode = nil
                }
            }
        }
        
        self.task = task
        task.resume()
    }
}

// создаем запрос к usplash по схеме Authorization workflow
extension OAuthService {
    
    func requestAuthToken(code: String) -> URLRequest? {
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
