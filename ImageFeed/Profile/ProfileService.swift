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
    private var profile: Profile?
    var profileRequest: URLRequest? {
        URLRequest.makeHttpRequest(path: "/me", httpMethod: "GET")
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if profile != nil { return }
        task?.cancel()
        
        var requestProfile = profileRequest
        requestProfile?.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        guard let requestProfile = requestProfile else { return }
        
        let task = urlSession.data(for: requestProfile) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let body):
                    let profile = Profile(
                        username: body.username,
                        name: "\(body.firstName) \(body.lastName)",
                        bio: body.bio ?? "No Bio")
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

// структура для ответа с пользовательским инфо с unsplash
struct ProfileResult: Codable {
    
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
    
}

// структура для ui эллементов
struct Profile {
    let username: String
    let name: String
    let bio: String
    var loginName: String {
        get { "@\(username)" }
    }
    
}
