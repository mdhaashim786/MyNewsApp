//
//  NewsTab.swift
//  MyNewsApp
//
//  Created by mhaashim on 19/03/25.
//

import SwiftUI
import WebKit
import CoreData

struct NewsTab: View {
    @ObservedObject var viewModel: NewsViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.articles) { article in
                NavigationLink(destination: NewsWebView(article: article, isSaved: false)) {
                    NewsRowView(article: article)
                }
            }
            .navigationTitle("Tech News")
            .onAppear {
                viewModel.fetchNews()
            }
        }
    }
}
