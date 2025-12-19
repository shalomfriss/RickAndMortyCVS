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
                VStack {
                    Text(character.name)
                        .font(.title3)
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
                }
                .frame(width: geometry.size.width)
            }
        }
    }
}

//#Preview {
//    RickAndMortyDetailView()
//}
