//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 22.08.2023.
//

import Foundation


final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private struct Keys {
        static let authorization = "Authorization"
        static let bearer = "Bearer"
        static let noBio = "no bio"
        static let httpMethod = "GET"
        static let URL = "URL"
    }
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if avatarURL != nil { return }
        task?.cancel()
        
        var requestImage = profileImageURLRequest(userName: username)
        requestImage?.addValue("\(Keys.bearer) \(token)", forHTTPHeaderField: Keys.authorization)
        
        guard let requestImage = requestImage else { return }
        
        let task = urlSession.objectTask(for: requestImage) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                    
                case .success(let body):
                    let avatarURL = body.profileImage?.small
                    guard let avatarURL = avatarURL else { return }
                    self.avatarURL = avatarURL
                    completion(.success(avatarURL))
                    NotificationCenter.default.post(
                            name: ProfileImageService.DidChangeNotification,
                            object: self,
                            userInfo: [Keys.URL: avatarURL])
                    self.task = nil
                    
                case .failure(let error):
                    completion(.failure(error))
                    self.avatarURL = nil
                }
            }
        }
        
        self.task = task
        task.resume()
    }
    
}

extension ProfileImageService {
    // функция получения картинки профиля
    func profileImageURLRequest(userName: String) -> URLRequest? {
        URLRequest.makeHttpRequest(
            path: "/users/\(userName)",
            httpMethod: Keys.httpMethod)
    }
    
}

extension ProfileImageService {
    // структура для сохранения ответа изображения профиля
    struct UserResult: Codable {
        let profileImage: ProfileImage?
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }
    
    // unspalsh "profile_image" response
    struct ProfileImage: Codable {
        let small: String?
        let medium: String?
        let large: String?
    }
    
}

