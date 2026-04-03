//
//  FeaturedCard.swift
//  Layman
//
//  Created by Aryan Gupta on 01/04/26.
//

import SwiftUI

struct FeaturedCard: View {

    let article: Article

    var body: some View {

        ZStack(alignment: .bottomLeading) {

            AsyncImage(
                url: URL(string: article.image_url ?? "")
            ) { image in

                image.resizable()

            } placeholder: {

                Color.gray
            }

            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )

            Text(article.title)
                .foregroundColor(.white)
                .padding()
        }
        .cornerRadius(16)
        .padding(.horizontal)
    }
}
