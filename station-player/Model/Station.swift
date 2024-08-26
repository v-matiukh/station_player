//
//  Station.swift
//  station-player
//
//  Created by Volodymyr Matiukh on 26.08.2024.
//

import Foundation

struct Station: Codable, Identifiable {
    let id: String
    let description: String
    let name: String
    let imgUrl: String?
    let streamUrl: String
    let reliability: Int
    let popularity: Double?
    let tags: [String]
    
    var imageURL: URL? {
        guard let imgUrl else {
            return nil
        }
        return URL(string: imgUrl)
    }
    
    var trackUrl: URL? {
        return URL(string: streamUrl)
    }
    
    var popularityValue: Double {
        popularity ?? 0
    }
}

extension Station: Equatable {
    
}
