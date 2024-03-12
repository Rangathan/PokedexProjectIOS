//
//  NetworkManager.swift
//  PokedexProjectIOS
//
//  Created by Adam Kreykenbohm on 2024-03-10.
//
import Foundation


enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchPokemonPage(completion: @escaping (Result<PokemonPage, Error>) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidURL))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let pokemonPage = try JSONDecoder().decode(PokemonPage.self, from: data)
                completion(.success(pokemonPage))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
}


