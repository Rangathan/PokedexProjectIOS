//
//  ViewModel.swift
//  PokedexProjectIOS
//
//  Created by Adam Kreykenbohm on 2024-03-05.
//

import Foundation
import Combine


class ViewModel: ObservableObject {
    @Published var pokemonList: [Pokemon] = []
       @Published var isLoading = false
       @Published var selectedPokemon: Pokemon? // Change type to Pokemon

       @Published var pokemonDetails: PokemonDetails? // Store PokemonDetails separately for the selected Pokemon

       private var cancellables = Set<AnyCancellable>()

    
    func fetchData() {
        isLoading = true
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=1025&offset=0") else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PokemonPage.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.isLoading = false
                case .failure(let error):
                    print("Error: \(error)")
                    self.isLoading = false
                }
            }, receiveValue: { [weak self] (pokemonListResponse: PokemonPage) in
                // Handle the received PokemonListResponse
                guard let self = self else { return }
                self.pokemonList = pokemonListResponse.results
            })
            .store(in: &cancellables)
    }
    
    func pokemonDetails(for pokemon: Pokemon) -> PokemonDetails? {
        // Check if the URL of the Pokemon is valid
        guard let pokemonURL = URL(string: pokemon.url) else {
            print("Invalid Pokemon URL")
            return nil
        }
        
        // Fetch the details for the given Pokemon
        URLSession.shared.dataTask(with: pokemonURL) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching Pokemon details: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let pokemonDetails = try JSONDecoder().decode(PokemonDetails.self, from: data)
                DispatchQueue.main.async {
                    self.pokemonDetails = pokemonDetails
                }
            } catch {
                print("Error decoding Pokemon details: \(error)")
            }
        }.resume()
        
        // Return nil temporarily as the details are being fetched asynchronously
        return nil
    }
}



