//
//  PokemonItemView.swift
//  PokedexProjectIOS
//
//  Created by Adam Kreykenbohm on 2024-03-05.
//

import SwiftUI
import Combine

struct PokemonItemView: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            Text(pokemon.name)
        }
        .padding(.all, 16)
        .overlay(
            RoundedRectangle(cornerRadius: 40)
                .stroke(.gray, lineWidth: 1)
        )
    }
}



