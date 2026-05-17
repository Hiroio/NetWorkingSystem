//
//  ProductCardView.swift
//  AdvancedNetworking
//
//  Created by Stephan Dowless on 2/23/26.
//

import SwiftUI
import Kingfisher

struct ProductCardView: View {
    let product: Product
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack {
                KFImage(URL(string: product.images.first ?? ""))
                    .placeholder {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(.gray.opacity(0.12))
                            
                            ProgressView()
                        }
                    }
                    .resizable()
                    .scaledToFill()
                .frame(width: 92, height: 92)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                
                if let categoryName = product.category?.name {
                    Text(categoryName.uppercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text(product.title)
                        .font(.headline)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Text("$\(product.price)")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.blue)
                }
                                
                Text(product.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.black.opacity(0.04), lineWidth: 1)
        )
    }
}
