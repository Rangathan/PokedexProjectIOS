//
//  PokemonItemView.swift
//  PokedexProjectIOS
//
//  Created by Adam Kreykenbohm on 2024-03-05.
//

import SwiftUI
import Combine
import AVKit
import AVFoundation
import OggDecoder


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
    let pokemonDetails: PokemonDetails?
    @State private var player: AVPlayer?

    var body: some View {
        VStack {
            if let pokemonDetails = pokemonDetails {
                VStack(spacing: 20) {
                    PokemonHeader(name: pokemonDetails.name, id: pokemonDetails.id, weight: pokemonDetails.weight, spriteURL: pokemonDetails.sprites.frontDefault)
                        .padding()
                        .background(determineBackgroundColor(for: pokemonDetails))
                        .cornerRadius(10)
                    
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)], spacing: 20) {
                        PokemonSectionView(title: "Abilities", items: pokemonDetails.abilities.prefix(5).map { $0.ability.name.capitalized })
                        PokemonSectionView(title: "Moves", items: pokemonDetails.moves.prefix(5).map { $0.move.name.capitalized })
                        PokemonSectionView(title: "Types", items: pokemonDetails.types.prefix(5).map { $0.type.name.capitalized })
                        PokemonSectionView(title: "Stats", items: pokemonDetails.stats.prefix(3).map { "\($0.stat.name.capitalized): \($0.baseStat)" })
                    }
                    .padding()
                }
                .onAppear {
                    if let soundURL = URL(string: pokemonDetails.cries.legacy) {
                        let decoder = OGGDecoder()
                        decoder.decode(soundURL) { savedWavUrl in
                            if let savedWavUrl = savedWavUrl {
                                self.player = AVPlayer(url: savedWavUrl)
                                self.player?.play()
                            } else {
                                print("Failed to decode .ogg file.")
                            }
                        }
                    }
                }
            } else {
                Text("Pokemon details not available")
            }
        }
        .padding()
    }
    
    private func determineBackgroundColor(for pokemonDetails: PokemonDetails) -> Color {
        guard let type = pokemonDetails.types.first?.type.name.lowercased() else {
            // Default color if details are not available
            return Color.gray
        }
        
        switch type {
        case "normal":
            return Color(hex: "A8A77A")
        case "fire":
            return Color(hex: "EE8130")
        case "water":
            return Color(hex: "6390F0")
        case "electric":
            return Color(hex: "F7D02C")
        case "grass":
            return Color(hex: "7AC74C")
        case "ice":
            return Color(hex: "96D9D6")
        case "fighting":
            return Color(hex: "C22E28")
        case "poison":
            return Color(hex: "A33EA1")
        case "ground":
            return Color(hex: "E2BF65")
        case "flying":
            return Color(hex: "A98FF3")
        case "psychic":
            return Color(hex: "F95587")
        case "bug":
            return Color(hex: "A6B91A")
        case "rock":
            return Color(hex: "B6A136")
        case "ghost":
            return Color(hex: "735797")
        case "dragon":
            return Color(hex: "6F35FC")
        case "dark":
            return Color(hex: "705746")
        case "steel":
            return Color(hex: "B7B7CE")
        case "fairy":
            return Color(hex: "D685AD")
        case "stellar":
            return Color(hex: "F7D02C")
        default:
            return Color.gray
        }
    }
}



struct PokemonSectionView: View {
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            ForEach(items, id: \.self) { item in
                Text(item)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}


struct PokemonHeader: View {
    let name: String
    let id: Int?
    let weight: Int?
    let spriteURL: String
    
    var body: some View {
        VStack {
            VStack {
                if let id = id, let weight = weight {
                    HStack {
                        Text("ID: \(id)")
                        Spacer()
                        Text("Weight: \(weight) KG")
                    }
                    .padding(.horizontal)
                }
                Text("\(name.capitalized)")
                    .font(.title)
            }
            .frame(maxWidth: .infinity)
            AsyncImage(url: URL(string: spriteURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 200)
        }
    }
}

// Other views remain the same


struct PokemonAbilities: View {
    let abilities: [Ability]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Abilities:")
                .font(.headline)
            ForEach(abilities, id: \.self) { ability in
                Text(ability.ability.name.capitalized)
            }
        }
    }
}

struct PokemonMoves: View {
    let moves: [Move]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Moves:")
                .font(.headline)
            ForEach(moves, id: \.self) { move in
                Text(move.move.name.capitalized)
            }
        }
    }
}

struct PokemonTypes: View {
    let types: [Type]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Types:")
                .font(.headline)
            ForEach(types, id: \.self) { type in
                Text(type.type.name.capitalized)
            }
        }
    }
}

struct PokemonStats: View {
    let stats: [Stat]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Stats:")
                .font(.headline)
            ForEach(stats, id: \.self) { stat in
                Text("\(stat.stat.name.capitalized): \(stat.baseStat)")
            }
        }
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





