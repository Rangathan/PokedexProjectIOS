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
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchData() {
        isLoading = true
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/") else {
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
}


