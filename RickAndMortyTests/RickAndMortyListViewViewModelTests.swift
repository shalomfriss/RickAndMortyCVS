//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Friss, Shay (206845153) on 12/18/25.
//

import Foundation
import Testing
@testable import RickAndMorty


struct RickAndMortyListViewViewModelTests {
    @Test func testViewModel() async throws {
        let mockRepo = MockCharacterRepository()
        let sut = await RickAndMortyListViewViewModel(repository: mockRepo)
        let characters = try await sut.repository.searchCharacters(name: "test")
        #expect(characters.count == 1)
        #expect(characters.first?.name == "model name")
        #expect(characters.first?.image == "model image")
        #expect(characters.first?.species == "model species")
        #expect(characters.first?.status == "model status")
        #expect(characters.first?.origin.name == "model origin name")
        #expect(characters.first?.origin.url == "model origin url")
        #expect(characters.first?.type == "model type")
        #expect(characters.first?.createdDate == "model date")
    }
}

final class MockCharacterRepository: CharacterRepositoryProtocol {
    let model = RickAndMorty.CharacterModel(name: "model name", image: "model image", species: "model species", status: "model status", origin: CharacterModel.Origin(name: "model origin name", url: "model origin url"), type: "model type", createdDate: "model date")

    func searchCharacters(name: String) async throws -> [RickAndMorty.CharacterModel] {
        return [model]
    }
}
