//
//  PokemonListView.swift
//  PokedexProjectIOS
//
//  Created by Adam Kreykenbohm on 2024-03-05.
//

import SwiftUI
import Combine




struct PokemonItemViewContainer: View {
    let pokemon: Pokemon
    let dimensions: Double = 140
    @ObservedObject var viewModel: PokemonListViewModel
    
    var body: some View {
        VStack {
            if let details = viewModel.pokemonDetails[pokemon.name] {
                VStack {
                    if let spriteURL = URL(string: details.sprites.frontDefault) {
                        AsyncImage(url: spriteURL) { image in
                            image
                                
                                 // Fixed size for image
                        } placeholder: {
                            ProgressView()
                                .frame(width: dimensions, height: dimensions)
                        }
                    }
                    
                    Text(pokemon.name)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .frame(width: dimensions) // Fixed width for text
                }
                .padding(8)
                .background(determineBackgroundColor())
                .clipShape(Circle())
                // Half of the width of VStack container
                // Fixed size for VStack container
            } else {
                ProgressView()
                    .onAppear {
                        viewModel.fetchPokemonDetails(for: pokemon)
                    }
                    .clipShape(Circle())
            }
        }
    }
    private func determineBackgroundColor() -> Color {
        guard let details = viewModel.pokemonDetails[pokemon.name],
              let type = details.types.first?.type.name.lowercased() else {
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
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0

        if scanner.scanHexInt64(&rgbValue) {
            let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = Double(rgbValue & 0x0000FF) / 255.0
            self.init(red: red, green: green, blue: blue)
            return
        }

        self.init(red: 0, green: 0, blue: 0) // Return black for any invalid input
    }
}



extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}









    
    
    
    









