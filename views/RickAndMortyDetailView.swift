//
//  RickAndMortyDetailView.swift
//  RickAndMorty
//
//  Created by Friss, Shay (206845153) on 12/18/25.
//

import SwiftUI
import Kingfisher

struct RickAndMortyDetailView: View {
    let character: CharacterModel
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 10) {
                    Text(character.name)
                        .font(.title3)
                        .accessibilityIdentifier("characterName")
                        .accessibilityLabel("character name")
                        .accessibilityHint("The name of the character")
                    KFImage(URL(string: character.image)!)
                        .placeholder {
                            ProgressView() // Show a progress indicator while loading
                        }
                    Text(character.species)
                    Text(character.status)
                    Text(character.origin.name)
                    if let type = character.type {
                        Text(type)
                    }
                    Text(character.createdDate)
                    ShareLink(item: URL(string: character.image)!,  message: Text("Name: \(character.name) species: \(character.species) origin: \(character.origin.name) type: \(String(describing: character.type ?? "none")) created: \(character.createdDate)")) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                .frame(width: geometry.size.width)
            }
        }
    }
}

//#Preview {
//    RickAndMortyDetailView()
//}
