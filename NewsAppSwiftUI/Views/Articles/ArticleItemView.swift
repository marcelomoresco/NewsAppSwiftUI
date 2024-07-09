//
//  ArticleItemView.swift
//  NewsAppSwiftUI
//
//  Created by Marcelo Moresco on 08/07/24.
//

import SwiftUI

struct ArticleItemView: View {
    
    let article: Article
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    
    var body: some View {
        VStack(alignment: .leading,spacing: 16) {
            AsyncImage(url: article.imageUrl) {
                phase in
                switch phase {
                case .empty:
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(_):
                    HStack {
                        Spacer()
                        Image(systemName: "photo")
                            .imageScale(.large )
                        Spacer()
                    }
                @unknown default:
                    fatalError()
                }
            }
            .frame(minHeight: 200, maxHeight: 300)
            .background(Color.gray.opacity(0.3))
            .clipped()
            
            VStack(alignment: .leading,spacing: 8) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(3)
                
                Text(article.descriptionText)
                    .font(.subheadline)
                    .lineLimit(2)
            }
            .padding([.horizontal, .bottom])
            
            HStack {
                Text(article.captionText)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                Spacer()
                
                Button {
                    toggleBookmark(for: article)
                } label: {
                    Image(systemName: articleBookmarkVM.isBookmarked(for: article) ? "bookmark.fill" : "bookmark")
                }
                .buttonStyle(.bordered)
                
                Button {
                    presentSharedSheet(url: article.articleURL)
                }label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .buttonStyle(.bordered)
            }
            .padding([.bottom, .horizontal])
            
            
        }
    }
    
    private func toggleBookmark(for article: Article) {
        if articleBookmarkVM.isBookmarked(for: article) {
            articleBookmarkVM.removeBookmark(for: article)
        } else {
            articleBookmarkVM.addBookmark(for: article)
        }
    }
}

extension View {
    func presentSharedSheet(url: URL) {
        let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .keyWindow?
            .rootViewController?
            .present(activity, animated: true)
    }
}

#Preview {
    NavigationView{
        List {
            ArticleItemView(article: .previewData[0]).listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.plain)
        
    }
}
