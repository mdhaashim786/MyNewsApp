//
//  NewsTab.swift
//  MyNewsApp
//
//  Created by mhaashim on 19/03/25.
//

import SwiftUI
import WebKit
import CoreData

enum NewsFilters: String, CaseIterable {
    case Business
    case Sports
    case Technology
    
}

struct NewsTab: View {
    @ObservedObject var viewModel: NewsViewModel
    @State private var filterOption: NewsFilters = .Business
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    FilterButton(title: "Business", isSelected: filterOption == .Business) {
                        filterOption = .Business
                    }
                    
                    FilterButton(title: "Technology", isSelected: filterOption == .Technology) {
                        filterOption = .Technology
                    }
                    
                    FilterButton(title: "Sports", isSelected: filterOption == .Sports) {
                        filterOption = .Sports
                    }
                    
                    Spacer()
                    
                    
                    
                }
                .padding(.leading, 20)

                Spacer()
                if viewModel.isLoading {
                    VStack(spacing: 20) {
                        ProgressView()
                            .progressViewStyle(.automatic)
                        Text("Loading...")
                            .font(.headline)
                    }
                }
                else if viewModel.articles.isEmpty {
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
                Spacer()
            }
            .navigationTitle("\(filterOption.rawValue) News")
            .onChange(of: filterOption) {
                viewModel.newsFilter = filterOption
                viewModel.fetchNews()

            }
            .onAppear {
                viewModel.newsFilter = filterOption
                viewModel.fetchNews()
            }
        }
    }
}


struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
 
    let selectedColor: Color = Color(red: 179/255, green: 255/255, blue: 179/255)
    let filterColor: Color = Color(red: 230/255, green: 230/255, blue: 230/255)
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundStyle(Color(red: 140/255, green: 140/255, blue: 140/255))
                .bold()
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
        }
        .background(isSelected ? selectedColor : filterColor)
        .cornerRadius(10)
    }
}
