//
//  StationListItemView.swift
//  station-player
//
//  Created by Volodymyr Matiukh on 26.08.2024.
//

import SwiftUI

struct StationListItemView: View {
    struct ContentData {
        let name: String
        let imageURL: URL?
        let description: String
        let popularity: String
    }
    let data: ContentData
    var body: some View {
        VStack(alignment: .leading) {
            HStack(content: {
                AsyncImage(url: data.imageURL) {
                    $0.resizable()
                } placeholder: {
                    Image(systemName: "photo.artframe")
                }
                .frame(width: 30, height: 30)
                .clipShape(.rect(cornerRadius: 5))
                Text(data.name)
                Spacer()
                Image(systemName: "star")
                    .frame(width: 10, height: 10)
                Text(data.popularity)
            })
            Text(data.description)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color(.systemGroupedBackground))
        .clipShape(.rect(cornerRadius: 10))
    }
}

