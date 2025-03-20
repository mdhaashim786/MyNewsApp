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
    @Binding var appColorMode: ColorScheme

    var body: some View {
        TabView {
            NewsTab(viewModel: viewModel, appColorMode: $appColorMode)
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
