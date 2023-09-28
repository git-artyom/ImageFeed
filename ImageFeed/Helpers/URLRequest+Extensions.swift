//
//  URLRequest+Extensions.swift
//  ImageFeed
//
//  Created by Артем Чебатуров on 03.08.2023.
//

import Foundation


extension URLRequest {
    
    // static - экземпляру не требуется вызывать статическую функцию, поскольку ее можно вызвать из самого типа
    static func makeHttpRequest(path: String, httpMethod: String, baseURL: URL? = Constants.DefaultBaseURL) -> URLRequest? {

        guard let baseURL = baseURL, let url = URL(string: path, relativeTo: baseURL) else {
            assertionFailure("не удалось создать url: \(path)")
            return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
        
   }
    
}
