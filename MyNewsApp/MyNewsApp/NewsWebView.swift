//
//  NewsWebView.swift
//  MyNewsApp
//
//  Created by mhaashim on 19/03/25.
//
import SwiftUI
import WebKit
import CoreData

struct NewsRowView: View {
    let article: Article
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 100, height: 100)
            .cornerRadius(8)
      
            
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.headline)
                Text(article.description ?? "")
                    .font(.subheadline)
                    .lineLimit(2)
            }
        }
    }
}


struct NewsWebView: View {
    let article: Article
    let isSaved: Bool
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            WebView(url: URL(string: article.url)!)
            
            if !isSaved {
                
                
                Button(action: saveArticle) {
                    Image(systemName: "bookmark.fill")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                        .padding()
                }
            }
        }
    }
    
    private func saveArticle() {
        
        let fetchRequest: NSFetchRequest<NewsArticle> = NewsArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", article.url) // Check if URL already exists
        
        do {
                let existingArticles = try viewContext.fetch(fetchRequest)
                if existingArticles.isEmpty { // Only save if not already saved
                    let savedArticle = NewsArticle(context: viewContext)
                    savedArticle.id = UUID()
                    savedArticle.title = article.title
                    savedArticle.titleDescription = article.description
                    savedArticle.url = article.url
                    savedArticle.urlToImage = article.urlToImage
                    
                    try viewContext.save()
                    print("Article saved successfully!")
                } else {
                    print("Article already saved, skipping duplicate entry.")
                }
            } catch {
                print("Failed to check existing article: \(error.localizedDescription)")
            }
        
    }
}


struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}
