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
            VStack {
                if viewModel.articles.isEmpty {
                    VStack {
                        Image(systemName: "tray.fill")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No news feed available yet!")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding()
                    }
                } else {
                    List(viewModel.articles) { article in
                        NavigationLink(destination: NewsWebView(article: article, isSaved: false)) {
                            NewsRowView(article: article)
                        }
                    }
                }
            }
            .navigationTitle("Tech News")
            .onAppear {
                viewModel.fetchNews()
            }
        }
    }
}
