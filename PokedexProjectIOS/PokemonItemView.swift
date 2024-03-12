//
//  PokemonItemView.swift
//  PokedexProjectIOS
//
//  Created by Adam Kreykenbohm on 2024-03-05.
//

import SwiftUI
import Combine

struct PokemonItemView: View {
    let pokemonDetails: PokemonDetails?
    
    var body: some View {
        HStack {
            if let spriteURL = URL(string: pokemonDetails?.sprites.frontDefault ?? "") {
                AsyncImage(url: spriteURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                } placeholder: {
                    ProgressView()
                }
            }
            Text(pokemonDetails?.name ?? "Unknown")
        }
        .padding(.vertical, 8)
    }
}

struct PokemonDetailView: View {
    let pokemonDetails: PokemonDetails
    
    var body: some View {
        VStack {
            Text("Name: \(pokemonDetails.name)")
            if let spriteURL = URL(string: pokemonDetails.sprites.frontDefault) {
                AsyncImage(url: spriteURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
            }
            // Display other details as needed
        }
        .padding()
    }
}


class PokemonDetailsViewModel: ObservableObject {
    @Published var pokemonDetails: PokemonDetails?
    
    func fetchPokemonDetails(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
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
    }
}





