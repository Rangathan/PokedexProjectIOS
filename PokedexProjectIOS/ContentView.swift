//
//  ContentView.swift
//  PokedexProjectIOS
//
//  Created by Adam Kreykenbohm on 2024-03-05.
//

import SwiftUI
import Combine
struct ContentView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    @State private var isShowingPokemonDetails = false
    @State private var searchText = ""
    
    let adaptiveColumns = [
        GridItem(.adaptive(minimum: 150), spacing: 10)
    ]
    
    var body: some View {
        ZStack {
            Color(hex: "b0c6d7") // Background color
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("PokeDex")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
                    .padding(.bottom, 8)
                    .foregroundColor(.white) // Title text color
                
                TextField("Search Pokemon", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: searchText) { newValue in
                        viewModel.filterPokemonList(with: newValue)
                    }
                    .font(.title)
                    .padding()
                    .background(Color.white.opacity(0.8)) // Search bar background color
                    .cornerRadius(10) // Search bar corner radius
                
                ScrollView {
                    LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                        ForEach(viewModel.filteredPokemonList, id: \.id) { pokemon in
                            PokemonItemViewContainer(pokemon: pokemon, viewModel: viewModel)
                                .onTapGesture {
                                    viewModel.selectedPokemon = pokemon
                                    viewModel.fetchPokemonDetails(for: pokemon)
                                    isShowingPokemonDetails = true
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true) // Hide the navigation bar
        }
        .sheet(isPresented: $isShowingPokemonDetails) {
            if let selectedPokemon = viewModel.selectedPokemon,
               let pokemonDetails = viewModel.pokemonDetails[selectedPokemon.name] {
                PokemonDetailView(pokemonDetails: pokemonDetails)
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}
extension Color {
    init(hex: Int, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



