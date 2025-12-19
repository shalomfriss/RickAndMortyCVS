//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by Friss, Shay (206845153) on 12/18/25.
//

import Foundation
import SwiftData

@Model
final class CharacterModel: Sendable, Identifiable {
    public struct Origin: Codable {
        let name: String
        let url: String
    }

    var name: String
    var image: String
    var species: String
    var status: String
    var origin: Origin
    var type: String?
    var createdDate: String

    init(name: String,
         image: String,
         species: String,
         status: String,
         origin: Origin,
         type: String?,
         createdDate: String,
    ) {
        self.name = name
        self.image = image
        self.species = species
        self.status = status
        self.origin = origin
        self.type = type
        self.createdDate = createdDate
    }
}
