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
    
    @ObservedObject var networkMonitor = NetworkManager()
    
    @State private var showAlert: Bool = false
    @State private var alertTtile: String = ""
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if networkMonitor.isConnected {
                WebView(url: URL(string: article.url)!) // Online mode
            } else {
                OfflineWebView(article: article) // Offline mode
            }
            
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
                    
                    fetchAndSaveHTML(for: article)
                    
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
    
    func fetchAndSaveHTML(for article: Article) {
        guard  let url = URL(string: article.url) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let htmlContent = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.saveArticleHTML(url: article.url, htmlContent: htmlContent)
                }
            } else {
                print("Failed to fetch HTML: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
    }
    
    func saveArticleHTML(url: String, htmlContent: String) {
        let request: NSFetchRequest<NewsArticle> = NewsArticle.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)
        
        if let savedArticle = try? viewContext.fetch(request).first {
            savedArticle.htmlContent = htmlContent
            try? viewContext.save()
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


struct OfflineWebView: UIViewRepresentable {
    let article: Article

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        if let htmlContent = article.htmlContent, !htmlContent.isEmpty {
            webView.loadHTMLString(htmlContent, baseURL: nil) // Load offline
        }
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

