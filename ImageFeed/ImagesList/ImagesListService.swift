//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 30.08.2023.
//

import Foundation

final class ImagesListService {
    
    private struct Keys {
        static let nameNotification = "ImagesListServiceDidChange"
        static let bearer = "Bearer"
        static let authorization = "Authorization"
        static let photos = "Photos"
    }
    
    private let urlSession = URLSession.shared
    private let token = OAuthTokenStorage().token
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private (set) var photos: [Photo] = []
    static let DidChangeNotification = Notification.Name(rawValue: Keys.nameNotification)
    
    
    func fetchPhotosNextPage() {
        let nextPage = getNextPageNumber()
        
        assert(Thread.isMainThread)
        if task != nil { return }
        guard let token = token else { return }
        var requestPhotos = photosRequest(page: nextPage, perPage: 10)
        requestPhotos?.addValue("\(Keys.bearer) \(token)", forHTTPHeaderField: Keys.authorization)
        guard let requestPhotos = requestPhotos else { return }
        
        let task = urlSession.objectTask(for: requestPhotos) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let body):
                    body.forEach { photo in
                        self.photos.append(
                            Photo(id: photo.id, size: CGSize(width: photo.width, height: photo.height),
                                  createdAt: DateService.shared.dateFromString(str: photo.createdAt),
                                  welcomeDescription: photo.description,
                                  thumbImageURL: photo.urls.thumb,
                                  largeImageURL: photo.urls.full,
                                  isLiked: photo.likedByUser)
                        )
                        
                    }
                    
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(
                            name: ImagesListService.DidChangeNotification,
                            object: self,
                            userInfo: [Keys.photos: self.photos]
                        )
                    
                    self.task = nil
                case .failure:
                    assertionFailure("failed to load photos")
                }
            }
        }
        self.task = task
        task.resume()
    }
    
}

private extension ImagesListService {

    
    func getNextPageNumber() -> Int {
        guard let lastLoadedPage = lastLoadedPage else { return 1 }
        return lastLoadedPage + 1
    }
    
    // функция запроса изображений по страницам
    func photosRequest(page: Int, perPage: Int) -> URLRequest? {
        URLRequest.makeHttpRequest(path: "/photos" + "?page=\(page)" + "&&per_page=\(perPage)", httpMethod: "GET")
    }
    
}
