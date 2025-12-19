//
//  CharacterRepository.swift
//  RickAndMorty
//
//  Created by Friss, Shay (206845153) on 12/18/25.
//

import Foundation

final class CharacterRepository {
    var characters: [CharacterModel] = []
    func searchCharacters(name: String) async throws -> [CharacterModel] {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        let urlString = "https://rickandmortyapi.com/api/character/?name=\(encodedName)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let response = try JSONDecoder().decode(CharactersDTO.self, from: data)

            var characters = [CharacterModel]()
            for character in response.results {
                let characterModel = CharacterModel(name: character.name,
                                                    image: character.image,
                                                    species: character.species,
                                                    status: character.status,
                                                    origin: CharacterModel.Origin(name: character.origin.name, url: character.origin.url),
                                                    type: character.type,
                                                    createdDate: character.created)
                characters.append(characterModel)
            }
            return characters
        } catch {
            print(error)
            return [CharacterModel]()
        }
    }
}
