//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Friss, Shay (206845153) on 12/18/25.
//

import SwiftUI
import SwiftData

struct RickAndMortyListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var characters: [CharacterModel]
    @State private var viewModel = RickAndMortyListViewViewModel(repository: CharacterRepository())
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($viewModel.characters) { character in
                    NavigationLink {
                        RickAndMortyDetailView(character: character.wrappedValue)
                    } label: {
                        Text(character.name.wrappedValue)
                            .font(.body)
                    }
                }
            }
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Rick")
            .onChange(of: searchText) { oldValue, newValue in
                if searchText.isEmpty { return }
                Task {
                    try await viewModel.search(newValue)
                    deleteAllCharactersFromSwiftData()
                    saveCharactersToSwiftData()
                }
            }
        }
        .onAppear {
            Task {
                viewModel.characters = characters
            }
        }
    }

    private func deleteAllCharactersFromSwiftData() {
        do {
            try modelContext.delete(model: CharacterModel.self)
        } catch {
            print(error)
        }
    }

    private func saveCharactersToSwiftData() {
        for character in viewModel.characters {
            modelContext.insert(character)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}

//
//#Preview {
//    RickAndMortyListView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
