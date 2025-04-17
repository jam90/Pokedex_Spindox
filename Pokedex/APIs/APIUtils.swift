//
//  APIUtils.swift
//  Pokedex
//
//  Created by Elia Crocetta on 12/04/25.
//

import SwiftUI

protocol APIManagerProtocol {
    var session: URLSession { get }
    func callApi<T: Codable>(endPoint: Endpoint) async throws -> T
}

extension APIManagerProtocol {
    /// Performs a generic API call and decodes the result into the specified type.
    ///
    /// - Parameter endPoint: The endpoint from which to fetch data.
    /// - Throws: `APIError.invalidURL`, `APIError.unexpectedResponse`, or `APIError.decodingFailed`.
    /// - Returns: A decoded instance of the requested Codable type `T`.
    func callApi<T: Codable>(endPoint: Endpoint) async throws -> T {
        guard let url = endPoint.url else {
            throw APIError.invalidURL
        }
        let request = URLRequest(url: url)
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw APIError.unexpectedResponse
            }
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                throw APIError.unexpectedResponse
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decodingFailed
            }
        } catch {
            throw APIError.unexpectedResponse
        }
    }
}

/// An enum with all the needed endpoints, with the needed parameters
enum Endpoint {
    case list(offset: Int)
    case pokemon(name: String)
    case abilities(name: String)
    case moves(name: String)
    case imageThumbnail(id: Int)
    case imageBig(id: Int)
    
    /// Constructs the full URL based on the specific API endpoint case.
    ///
    /// - Returns: A `URL` representing the API call, or `nil` if construction fails.
    var url: URL? {
        let baseHostPokemon = "pokeapi.co"
        let baseHostImages = "raw.githubusercontent.com"
        let pathPokemon = "/api/v2/pokemon"
        let pathAbilities = "/api/v2/ability"
        let pathMoves = "/api/v2/move"
        let pathImageThumbnail = "/PokeAPI/sprites/master/sprites/pokemon"
        let pathImageBig = "/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        
        switch self {
        case .list(let offset):
            urlComponents.host = baseHostPokemon
            urlComponents.path = pathPokemon
            urlComponents.queryItems = [
                URLQueryItem(name: "limit", value: "20"),
                URLQueryItem(name: "offset", value: "\(offset)")
            ]
            return urlComponents.url
        case .pokemon(let name):
            urlComponents.host = baseHostPokemon
            urlComponents.path = pathPokemon + "/\(name)"
            return urlComponents.url
        case .abilities(let name):
            urlComponents.host = baseHostPokemon
            urlComponents.path = pathAbilities + "/\(name)"
            return urlComponents.url
        case .moves(let name):
            urlComponents.host = baseHostPokemon
            urlComponents.path = pathMoves + "/\(name)"
            return urlComponents.url
        case .imageThumbnail(let id):
            urlComponents.host = baseHostImages
            urlComponents.path = pathImageThumbnail + "/\(id).png"
            return urlComponents.url
        case .imageBig(let id):
            urlComponents.host = baseHostImages
            urlComponents.path = pathImageBig + "/\(id).png"
            return urlComponents.url
        }
    }
}

/// An enum with the errors that can occur during API interactions.
enum APIError: LocalizedError {
    case invalidURL
    case unexpectedResponse
    case decodingFailed
    
}

private struct URLSessionKey: EnvironmentKey {
    static let defaultValue: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        
        return URLSession(configuration: configuration)
    }()
}

extension EnvironmentValues {
    /// A custom `URLSession` instance injected into the environment.
    ///
    /// Provides a session with specific configuration for use in API requests.
    var urlSession: URLSession {
        get {
            self[URLSessionKey.self]
        }
        set {
            self[URLSessionKey.self] = newValue
        }
    }
}
