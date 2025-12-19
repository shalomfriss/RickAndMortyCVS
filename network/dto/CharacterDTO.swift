//
//  CharacterDTO.swift
//  RickAndMorty
//
//  Created by Friss, Shay (206845153) on 12/18/25.
//
import Foundation

struct CharacterDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let image: String
    let origin: OriginDTO
    let created: String

    struct OriginDTO: Codable {
        let name: String
        let url: String
    }

//    var formattedCreatedDate: String {
//        let isoFormatter = ISO8601DateFormatter()
//        if let date = isoFormatter.date(from: created) {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateStyle = .long
//            dateFormatter.timeStyle = .none
//            return dateFormatter.string(from: date)
//        }
//        return created
//    }
}
