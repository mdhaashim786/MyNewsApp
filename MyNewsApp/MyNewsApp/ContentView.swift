//
//  ContentView.swift
//  MyNewsApp
//
//  Created by mhaashim on 19/03/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @StateObject private var viewModel = NewsViewModel()

    var body: some View {
        TabView {
            NewsTab(viewModel: viewModel)
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
            SavedNewsTab()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
        }
    }
}
