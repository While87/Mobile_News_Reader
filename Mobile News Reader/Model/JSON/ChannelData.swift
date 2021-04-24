//
//  ChannelData.swift
//  Mobile News Reader
//
//  Created by Vladimir Gorbunov on 13.04.2021.
//

import Foundation

struct ChannelData: Codable {
    let sources: [Sources]
}

struct Sources: Codable {
    let id: String
    let name: String
    let description: String
}
