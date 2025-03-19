//
//  NewsApiResponse.swift
//  MyNewsApp
//
//  Created by mhaashim on 19/03/25.
//

import SwiftUI

// Introducing this structure because Core Data only supports classes that inherit from NSManagedObject.
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

extension NewsArticle {
    // This converts the CoreData entity to our local structure
    func toArticle() -> Article {
        return Article(
            title: title ?? "",
            description: titleDescription,
            url: url ?? "",
            urlToImage: urlToImage,
            publishedAt: publishedAt ?? "",
            content: content
        )
    }
}
