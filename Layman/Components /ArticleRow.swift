//
//  ArticleRow.swift
//  Layman
//
//  Created by Aryan Gupta on 01/04/26.
//

import SwiftUI

struct ArticleRow: View {

    let article: Article

    var body: some View {

        HStack {

            AsyncImage(
                url: URL(string: article.image_url ?? "")
            ) { image in

                image.resizable()

            } placeholder: {

                Color.gray
            }
            .frame(width: 80, height: 80)
            .cornerRadius(10)

            Text(article.title)
                .font(.headline)

            Spacer()
        }
        .padding()
    }
}
