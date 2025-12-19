//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Friss, Shay (206845153) on 12/18/25.
//

import Foundation
import Testing
@testable import RickAndMorty
enum TestError: Error {
    case invalidResponse
}

struct RickAndMortyListViewViewModelTests {

    let sampleJson = """
        {
          "info": {
            "count": 2,
            "pages": 1,
            "next": null,
            "prev": null
          },
          "results": [
            {
              "id": 45,
              "name": "Bill test",
              "status": "Alive",
              "species": "Human",
              "type": "",
              "gender": "Male",
              "origin": {
                "name": "Earth (C-137)",
                "url": "https://rickandmortyapi.com/api/location/1"
              },
              "location": {
                "name": "Earth (C-137)",
                "url": "https://rickandmortyapi.com/api/location/1"
              },
              "image": "https://rickandmortyapi.com/api/character/avatar/45.jpeg",
              "episode": [
                "https://rickandmortyapi.com/api/episode/3"
              ],
              "url": "https://rickandmortyapi.com/api/character/45",
              "created": "2017-11-05T10:22:27.446Z"
            },
            {
              "id": 46,
              "name": "Bill test 2",
              "status": "unknown",
              "species": "Animal",
              "type": "Dog",
              "gender": "Male",
              "origin": {
                "name": "Earth (Replacement Dimension)",
                "url": "https://rickandmortyapi.com/api/location/20"
              },
              "location": {
                "name": "unknown",
                "url": ""
              },
              "image": "https://rickandmortyapi.com/api/character/avatar/46.jpeg",
              "episode": [
                "https://rickandmortyapi.com/api/episode/2"
              ],
              "url": "https://rickandmortyapi.com/api/character/46",
              "created": "2017-11-05T10:24:38.089Z"
            }
          ]
        }
    """

    private func makeSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: config)
    }


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


    @Test
    @BackgroundActor
    func mockShouldReturnDesiredData() async throws {
        let url = try #require(URL(string: "https://www.apple.com/"), "Bad URL")

        guard let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else {
            throw TestError.invalidResponse
        }

        // Arrange
        await URLProtocolMock.setHandler({ _ in
            (httpResponse, Data(sampleJson.utf8))
        })

        let repo = CharacterRepository()
        repo.urlSession = makeSession()
        let chars = try await repo.searchCharacters(name: "whatever")

        #expect(chars[0].name == "Bill test")
        #expect(chars[1].name == "Bill test 2")
    }

}

final class MockCharacterRepository: CharacterRepositoryProtocol {
    let model = RickAndMorty.CharacterModel(name: "model name", image: "model image", species: "model species", status: "model status", origin: CharacterModel.Origin(name: "model origin name", url: "model origin url"), type: "model type", createdDate: "model date")

    func searchCharacters(name: String) async throws -> [RickAndMorty.CharacterModel] {
        return [model]
    }
}
