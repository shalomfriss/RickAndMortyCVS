//
//  RickAndMortyListViewViewModel.swift
//  RickAndMorty
//
//  Created by Friss, Shay (206845153) on 12/18/25.
//

import Foundation
import SwiftUI

@Observable
final class RickAndMortyListViewViewModel {
    let repository: CharacterRepository
    var characters: [CharacterModel] = []

    init(repository: CharacterRepository) {
        self.repository = repository
    }
    
    public func search(_ query: String) async throws {
        do {
            characters = try await repository.searchCharacters(name: query)
        } catch {
            print(error)
        }
    }
}
