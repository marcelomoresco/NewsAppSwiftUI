//
//  NewsTabView.swift
//  NewsAppSwiftUI
//
//  Created by Marcelo Moresco on 09/07/24.
//

import SwiftUI

struct NewsTabView: View {
    
    @StateObject var articleNewsVM = ArticleNewsViewModel()
    
    var body: some View {
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .task(id: articleNewsVM.fetchTaskToken, loadTasks)
                .refreshable(action: refreshTask)
                .navigationTitle(articleNewsVM.fetchTaskToken.category.text)
                .navigationBarItems(trailing: menu)
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch articleNewsVM.phase {
        case .empty:
            ProgressView()
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No Articles", image: nil)
        case .failure(let error):
            RetryView(text: error.localizedDescription,retryAction: refreshTask)
        default:
            EmptyView()
        }
    }
    
    private var articles: [Article] {
        if case let .success(articles) = articleNewsVM.phase {
            return articles
        }
        return []
    }
    
    private func loadTasks() async{
        await articleNewsVM.loadArticles()
    }
    
    private func refreshTask(){
        articleNewsVM.fetchTaskToken = FetchTaskToken(category: articleNewsVM.fetchTaskToken.category, token: Date())
    }
    
    private var menu: some View {
        Menu {
            Picker("Category", selection: $articleNewsVM.fetchTaskToken.category) {
                ForEach(Category.allCases){
                    Text($0.text).tag($0)
                }
            }
            
        } label : {
            Image(systemName: "fiberchannel")
                .imageScale(.large)
        }
    }
}



#Preview {
    NewsTabView(articleNewsVM: ArticleNewsViewModel(articles: Article.previewData))
}
