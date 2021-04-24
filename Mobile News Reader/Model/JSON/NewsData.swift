//
//  NewsData.swift
//  Mobile News Reader
//
//  Created by Vladimir Gorbunov on 15.04.2021.
//

import Foundation

struct NewsData: Codable {
    let articles: [Articles]
}

struct Articles: Codable {
    let title : String
    let description: String?
    let content: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
}
