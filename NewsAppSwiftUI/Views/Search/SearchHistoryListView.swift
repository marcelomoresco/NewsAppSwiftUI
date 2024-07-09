//
//  SearchHistoryListView.swift
//  NewsAppSwiftUI
//
//  Created by Marcelo Moresco on 09/07/24.
//

import SwiftUI

struct SearchHistoryListView: View {
    
    @ObservedObject var searchVM: ArticleSearchViewModel
    let onSubit: (String) -> ()
    
    var body: some View {
        List {
            HStack {
                Text("Recently Search")
                Spacer()
                Button("Clean") {
                    searchVM.removeAllHistory()
                }
                .foregroundColor(.accentColor)
            }
            .listRowSeparator(.hidden)
            
            ForEach(searchVM.history, id: \.self) { history in
                Button(history) {
                    onSubit(history )
                }
                .swipeActions {
                    Button(role: .destructive) {
                        searchVM.removeHistory(history)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    SearchHistoryListView(searchVM: ArticleSearchViewModel.shared) { text in
        <#code#>
    }
}
