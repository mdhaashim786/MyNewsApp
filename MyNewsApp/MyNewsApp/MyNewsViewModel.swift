//
//  MyNewsViewModel.swift
//  MyNewsApp
//
//  Created by mhaashim on 19/03/25.
//

import SwiftUI

class NewsViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = true
    @Published var newsFilter: NewsFilters = .Business
    
    func fetchNews() {
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&category=\(newsFilter.rawValue)&apiKey=39e6e86fc4184a20b1c6710d60503475"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.articles = response.articles
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            if let error = error {
                self.isLoading = false
            }
        }.resume()
    }
}
