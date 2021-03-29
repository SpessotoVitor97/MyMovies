//
//  API.swift
//  MyMovies
//
//  Created by Vitor Spessoto on 03/03/21.
//

import Foundation

struct APIResult: Codable {
    let results: [Trailer]
}

struct Trailer: Codable {
    let previewUrl: String
}

class API {
    //*************************************************
    // MARK: - Properties
    //*************************************************
    static let basePath = "https://itunes.apple.com/search?media=movie&amp;entity=movie&amp;term="
    
    static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = ["Contet-Type": "application/json"]
        config.timeoutIntervalForRequest = 45.0
        config.httpMaximumConnectionsPerHost = 5
        
        return config
    }()
    
    static let session = URLSession(configuration: configuration)
    
    //*************************************************
    // MARK: - Public methods
    //*************************************************
    static func loadTrailers(title: String, onComplete: @escaping (APIResult?) -> Void) {
        guard let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: basePath+encodedTitle) else {
            onComplete(nil)
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
                onComplete(nil)
            } else {
                guard let response = response as? HTTPURLResponse else { onComplete(nil); return }
                
                if response.statusCode == 200 {
                    guard let data = data else { onComplete(nil); return }
                    
                    do {
                        let apiResult = try JSONDecoder().decode(APIResult.self, from: data)
                        onComplete(apiResult)
                    } catch {
                        print("Error while decoding JSON: \(error.localizedDescription)")
                        onComplete(nil)
                    }
                } else {
                    onComplete(nil)
                }
            }
        }
        task.resume()
    }
}
