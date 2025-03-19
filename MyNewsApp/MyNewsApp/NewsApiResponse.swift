//
//  NewsApiResponse.swift
//  MyNewsApp
//
//  Created by mhaashim on 19/03/25.
//

import SwiftUI

struct Article: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct NewsResponse: Codable {
    let articles: [Article]
    let status: String
    let totalResults: Int
}


