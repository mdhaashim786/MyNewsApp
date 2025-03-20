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
    @StateObject private var imageLoader = ImageLoader()
    var body: some View {
        HStack {
            
            //MARK: This can be commented to use cached image loader and uncomment the below code
            
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 100, height: 100)
            .cornerRadius(8)
            /*
             
             //MARK: This below UI can be used to cache the image instead of above AsyncImage
             
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
            } else {
                Color.gray
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
                    .onAppear {
                        imageLoader.loadImage(from: article.urlToImage)
                    }
            }
             */
            
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.headline)
                    .foregroundStyle(.black)
                Text(article.description ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .lineLimit(2)
            }
        }
    }
}


struct NewsWebView: View {
    let article: Article
    let isSaved: Bool
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showAlert: Bool = false
    @State private var alertTtile: String = ""
    
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTtile), dismissButton: .destructive(Text("OK")))
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
                    alertTtile = "Article saved successfully"
                    showAlert = true
                    print("Article saved successfully!")
                } else {
                    alertTtile = "Article already saved!"
                    showAlert = true
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
