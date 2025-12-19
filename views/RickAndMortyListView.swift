//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Friss, Shay (206845153) on 12/18/25.
//

import SwiftUI
import SwiftData
import Kingfisher

struct RickAndMortyListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var characters: [CharacterModel]
    @State private var viewModel = RickAndMortyListViewViewModel(repository: CharacterRepository())
    @State private var searchText: String = ""
    @State private var isLoading: Bool = false
    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView("Downloading...") // Optionally add a label
                            .progressViewStyle(CircularProgressViewStyle())
            }
            List {
                ForEach($viewModel.characters) { character in
                    NavigationLink {
                        RickAndMortyDetailView(character: character.wrappedValue)
                    } label: {
                        LazyHStack {
                            KFImage(URL(string: character.image.wrappedValue)!)
                                .placeholder {
                                    ProgressView() // Show a progress indicator while loading
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .border(Color.black, width: 1)

                            Text(character.name.wrappedValue)
                                .font(.body)
                        }

                    }
                }
            }
            .accessibilityIdentifier("searchableList")
            .accessibilityLabel("Search")
            .accessibilityHint("Search for a Rick or Morty character")
            .navigationTitle("Rick and Morty")
            .searchable(text: $searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Rick")
            .onChange(of: searchText) { oldValue, newValue in
                if searchText.isEmpty { return }
                Task {
                    isLoading = true
                    try await viewModel.search(newValue)
                    isLoading = false
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
