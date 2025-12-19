//
//  CharacterRepository.swift
//  RickAndMorty
//
//  Created by Friss, Shay (206845153) on 12/18/25.
//

import Foundation
import OSLog

protocol BackgroundActorProtocol: Actor {}

@globalActor
actor BackgroundActor: BackgroundActorProtocol {
    static let shared = BackgroundActor()
}

protocol CharacterRepositoryProtocol {
    func searchCharacters(name: String) async throws -> [CharacterModel]
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingFailed
}

@BackgroundActor
final class CharacterRepository: CharacterRepositoryProtocol {
    var urlSession: URLSession = .shared

    func searchCharacters(name: String) async throws -> [CharacterModel] {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        let urlString = "https://rickandmortyapi.com/api/character/?name=\(encodedName)"

        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await urlSession.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            Logger.network.error("Bad status code \(statusCode)")
            throw NetworkError.invalidResponse(statusCode: statusCode)
        }
        
        do {
            let response = try JSONDecoder().decode(CharactersDTO.self, from: data)

            var characters = [CharacterModel]()
            for character in response.results {
                let characterModel = await CharacterModel(name: character.name,
                                                    image: character.image,
                                                    species: character.species,
                                                    status: character.status,
                                                    origin: CharacterModel.Origin(name: character.origin.name, url: character.origin.url),
                                                    type: character.type,
                                                    createdDate: isoToReadableDate(character.created))
                characters.append(characterModel)
            }
            return characters
        } catch {
            Logger.network.error("Decoding failed")
            throw NetworkError.decodingFailed
        }
    }

    private func isoToReadableDate(_ isoString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = isoFormatter.date(from: isoString) else {
            return ""
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .short
        outputFormatter.locale = Locale.current
        outputFormatter.timeZone = TimeZone.current

        return outputFormatter.string(from: date)
    }

}
