//
//  Pokeapi.swift
//  PokedexProjectIOS
//
//  Created by Adam Kreykenbohm on 2024-03-05.
//
import Foundation

// Function to fetch Pokémon data from the PokeAPI
func fetchPokemon(completion: @escaping ([Pokemon]?, Error?) -> Void) {
    // URL for the PokeAPI /pokemon endpoint
    let url = URL(string: "https://pokeapi.co/api/v2/pokemon?")!
    
    // Create a URLSession data task to fetch data from the URL
    URLSession.shared.dataTask(with: url) { data, response, error in
        // Check for errors
        if let error = error {
            completion(nil, error)
            return
        }
        
        // Ensure that a successful response was received
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            completion(nil, NSError(domain: "HTTP Error", code: -1, userInfo: nil))
            return
        }
        
        // Ensure that data was returned
        guard let data = data else {
            completion(nil, NSError(domain: "No Data", code: -1, userInfo: nil))
            return
        }
        
        do {
            // Parse the JSON data into an array of Pokemon objects
            let decoder = JSONDecoder()
            let pokemonList = try decoder.decode([Pokemon].self, from: data)
            completion(pokemonList, nil)
        } catch {
            // Handle JSON parsing error
            completion(nil, error)
        }
    }.resume() // Start the URLSession data task
}


