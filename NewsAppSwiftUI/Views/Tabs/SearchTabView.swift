//
//  SearchTabView.swift
//  NewsAppSwiftUI
//
//  Created by Marcelo Moresco on 09/07/24.
//

import SwiftUI

struct SearchTabView: View {
    
    @StateObject var searchVM = ArticleSearchViewModel.shared
    
    var body: some View {
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .navigationTitle("Search")
        }
        .searchable(text: $searchVM.searchQuery) { suggestionsView }
        .onChange(of: searchVM.searchQuery) { newValue in
            if newValue.isEmpty {
                searchVM.phase = .empty
            }
        }
        .onSubmit(of: .search) {
            search()
        }
    }
    
    private var articles: [Article] {
        if case .success(let articles) = searchVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch searchVM.phase {
        case .empty:
            if !searchVM.searchQuery.isEmpty {
                ProgressView()
            } else if !searchVM.history.isEmpty {
                SearchHistoryListView(searchVM: searchVM) { text in
                    searchVM.searchQuery = text
                }
            } else {
                EmptyPlaceholderView(text: "Type your query to search", image: Image(systemName: "magnifyingglasss"))
            }
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No articles found", image: Image(systemName: "magnifyingglasss"))
        case .failure(let error):
            RetryView(text: error.localizedDescription) {
                search()
            }
        default: EmptyView()
        }
    }
    
    @ViewBuilder
    private var suggestionsView: some View {
        ForEach(["Swift", "Covid-19", "Flamengo", "Bitcoin", "Tesla"], id: \.self) { text in
            Button {
                searchVM.searchQuery = text
            } label: {
                Text(text)
            }
            
        }
    }
    
    private func search() {
        let searchQuery = searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if !searchQuery.isEmpty {
            searchVM.addHistory(searchQuery)
        }
        Task.init {
           await searchVM.searchArticle()
        }
    }
}

#Preview {
    SearchTabView()
}
