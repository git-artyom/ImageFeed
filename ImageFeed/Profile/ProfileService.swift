//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 20.08.2023.
//

import Foundation


final class ProfileService {
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    static let shared = ProfileService()
    private (set) var profile: Profile?
    private let OAuthToken = OAuthTokenStorage()
    
    private struct Keys {
        static let authorization = "Authorization"
        static let bearer = "Bearer"
        static let httpMethod = "GET"
    }
    
    var profileRequest: URLRequest? {
        URLRequest.makeHttpRequest(path: "/me", httpMethod: Keys.httpMethod)
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if profile != nil { return }
        task?.cancel()
        var requestProfile = profileRequest
        requestProfile?.addValue("\(Keys.bearer) \(token)", forHTTPHeaderField: Keys.authorization)
        guard let requestProfile = requestProfile else { return }
        let task = urlSession.objectTask(for: requestProfile) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let body):
                    let profile = Profile(
                        username: body.username,
                        name: "\(body.firstName) \(body.lastName)",
                        bio: body.bio ?? "No Bio")
                    print(profile)
                    self.profile = profile
                    completion(.success(profile))
                    self.task = nil
                    
                case .failure(let error):
                    completion(.failure(error))
                    self.profile = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
    
}
