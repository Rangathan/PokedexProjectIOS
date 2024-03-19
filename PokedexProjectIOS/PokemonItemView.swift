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
import UIKit


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

import OggDecoder

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
                    PokemonStatsSectionView(title: "Stats", items: pokemonDetails.stats.prefix(3).map { "\($0.stat.name.capitalized): \($0.baseStat)" })
                        .frame(width: 360, height: 80)                     
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    
                    LazyVGrid(columns: [GridItem(.fixed(220), spacing: 5), GridItem(.fixed(200), spacing: 5)]) {  
                        
                        PokemonSectionView(title: "Abilities", items: pokemonDetails.abilities.prefix(5).map { $0.ability.name.capitalized })
                            .frame(width: 150, height: 150)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        PokemonSectionView(title: "Types", items: pokemonDetails.types.prefix(5).map { $0.type.name.capitalized })
                            .frame(width: 150, height: 150)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.horizontal, 5)
                        
                    }
                    .padding()
                    PokemonStatsSectionView(title: "Moves", items: pokemonDetails.moves.prefix(4).map { $0.move.name.capitalized })
                        .frame(width: 360, height: 80)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                   
                }
                .onAppear {
                    if let soundURL = URL(string: pokemonDetails.cries.legacy) {
                        downloadAndPlaySound(url: soundURL)
                    }
                }
            } else {
                Text("Pokemon details not available")
            }
        }
        .padding()
    }
    
    private func downloadAndPlaySound(url: URL) {
        URLSession.shared.downloadTask(with: url) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let savedWavUrl = documentsDirectory.appendingPathComponent("tempSound.ogg")
                
                var finalSavedWavUrl = savedWavUrl
                
                if FileManager.default.fileExists(atPath: savedWavUrl.path) {
                    let uuid = UUID().uuidString
                    let newFileName = "tempSound_\(uuid).ogg"
                    finalSavedWavUrl = documentsDirectory.appendingPathComponent(newFileName)
                }
                
                do {
                    try FileManager.default.moveItem(at: tempLocalUrl, to: finalSavedWavUrl)
                    let decoder = OGGDecoder()
                    decoder.decode(finalSavedWavUrl) { (decodedUrl: URL?) in
                        if let decodedUrl = decodedUrl {
                            let playerItem = AVPlayerItem(url: decodedUrl)
                            self.player = AVPlayer(playerItem: playerItem)
                            self.player?.play()
                            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main) { (_) in
                                do {
                                    try FileManager.default.removeItem(at: finalSavedWavUrl)
                                } catch {
                                    print("Error deleting audio file: \(error)")
                                }
                            }
                        } else {
                            print("Error: Unable to decode the audio file.")
                        }
                    }
                } catch {
                    print("Error: \(error)")
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }

    
    
    private func determineBackgroundColor(for pokemonDetails: PokemonDetails) -> Color {
        guard let type = pokemonDetails.types.first?.type.name.lowercased() else {
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
struct PokemonStatsSectionView: View {
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding(.horizontal, 12)
                .padding(.top, 10)
            
            HStack(alignment: .center, spacing: 10) { // Provide alignment and spacing
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
        .padding(12)
        .padding(.horizontal, 12)
    }
}


struct PokemonSectionView: View {
    let title: String
    let items: [String]
    
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .padding(.top, 10)
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.secondary.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
            }
        .padding(12)
        .padding(.horizontal, 12)
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
                        Text("Weight: \(weight) lbs")
                    }
                    .padding(.horizontal)
                    
                }
                Text("\(name.capitalized)")
                    .font(.title)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 3)
            .padding(.horizontal, 5)
           
            AsyncImage(url: URL(string: spriteURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 175, height: 175)
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





