//
//  SavedNewsTab.swift
//  MyNewsApp
//
//  Created by mhaashim on 19/03/25.
//

import SwiftUI

struct SavedNewsTab: View {
    
    @FetchRequest(
        entity: NewsArticle.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \NewsArticle.title, ascending: true)]
    ) var newsArticles: FetchedResults<NewsArticle>
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(newsArticles, id: \.self) { savedArticle in
                        
                        SavedArticleRow(article: savedArticle, deleteAction: { deleteArticle(article: savedArticle) })
                            .padding()
                    }
                }
                .padding(.top)
            }
            
            .navigationTitle("Saved Articles")
        }
    }
    
    private func deleteArticle(article: NewsArticle) {
        
        viewContext.delete(article)
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete article: \(error.localizedDescription)")
        }
    }
}

struct SavedArticleRow: View {
    let article: NewsArticle
    let deleteAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            NavigationLink(destination: NewsWebView(article: article.toArticle(), isSaved: true)) {
                HStack(spacing: 12) {
                    NewsRowView(article: article.toArticle())
                }
            }
            
            HStack {
                Spacer()
                Button(action: deleteAction) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.red)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

