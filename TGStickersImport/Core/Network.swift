//
//  Network.swift
//  TGStickersImport
//
//  Created by Dmitry Starkov on 01/07/2021.
//

import Foundation
import Combine
#if DEBUG
import Lottie
#endif

struct Network {
    enum NetworkError: Error {
        case arguments
        case url
        case response
        case data
    }
    
    #if DEBUG
    static let base = "http://macpro.home:5000/avatar" // NSAppTransportSecurity dict NSAllowsArbitraryLoads YES
    #else
    static let base = "https://facemotion.herokuapp.com/avatar"
    #endif
    
    #if DEBUG
    /// Mocked animation network call.
    /// - Parameter json: Face features in JSON format
    /// - Returns: Mocked animation data or the data returned by Local Server based on `CommandLine.arguments` values
    static func load(for json: [String: Any]) throws -> AnyPublisher<Data, NetworkError> {
        if CommandLine.arguments.contains("-LOCAL") {
            guard let data = try? JSONSerialization.data(withJSONObject: json) else {
                throw NetworkError.arguments
            }

            guard let url = URL(string: base) else {
                throw NetworkError.url
            }
            
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("SERVER_TOKEN", forHTTPHeaderField: "Token")
            request.httpMethod = "POST"
            request.httpBody = data
                    
            return URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global())
                .retry(3)
                .tryMap() { request -> Data in
                    guard let httpResponse = request.response as? HTTPURLResponse,
                          200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.response
                    }
                    return request.data
                }
                .retry(3)
                .mapError { _ in NetworkError.data }
                .eraseToAnyPublisher()
        } else {
            return Future<Data, NetworkError> { promise in
                DispatchQueue.global().async {
                    let index = 3 // mocked sticker set
                    if let emotion = json["emotion"] as? String,
                       let path = Bundle.main.path(forResource: "\(emotion)_\(index)", ofType: "json", inDirectory: "MockupAnimations/avatar_\(index)"),
                        let escaped = try? Data(contentsOf: URL(fileURLWithPath: path)),
                        let string = String(data: escaped, encoding: .utf8),
                        let data = String(string.unescaped.dropFirst().dropLast()).data(using: .utf8) {
                        
                        promise(.success(data))
                    }
                    else {
                        promise(.failure(NetworkError.data))
                    }
                }
            }.eraseToAnyPublisher()
        }
    }
    #else
    /// Load animation from server based on face features provided
    /// - Parameter json: Face features in JSON format
    /// - Returns: Animation data
    static func load(for json: [String: Any]) throws -> AnyPublisher<Data, NetworkError> {
        guard let data = try? JSONSerialization.data(withJSONObject: json) else {
            throw NetworkError.arguments
        }

        guard let url = URL(string: base) else {
            throw NetworkError.url
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("SERVER_TOKEN", forHTTPHeaderField: "Token")
        request.httpMethod = "POST"
        request.httpBody = data
                
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global())
            .retry(3)
            .tryMap() { request -> Data in
                guard let httpResponse = request.response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode else {
                    throw NetworkError.response
                }
                return request.data
            }
            .retry(3)
            .mapError { _ in NetworkError.data }
            .eraseToAnyPublisher()
    }
    #endif
}
