//
//  ProductDetailView.swift
//  AdvancedNetworking
//
//  Created by Stephan Dowless on 2/23/26.
//

import SwiftUI
import Kingfisher

struct ProductDetailView: View {
  @Environment(ProductsViewModel.self) private var viewModel
    let product: Product
    @State private var isShowingEditForm = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                KFImage(URL(string: product.images.first ?? ""))
                    .placeholder {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.gray.opacity(0.12))
                            .overlay(ProgressView())
                    }
                    .resizable()
                    .scaledToFill()
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(alignment: .leading, spacing: 10) {
                    Text(product.title)
                        .font(.title2.bold())

                    Text("$\(product.price)")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.blue)

                    if let categoryName = product.category?.name {
                        Label(categoryName, systemImage: "tag")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Text(product.description)
                        .font(.body)
                        .foregroundStyle(.primary)
                }
            }
            .padding(16)
        }
        .navigationTitle("Product")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    isShowingEditForm = true
                }
            }
        }
		  .sheet(isPresented: $isShowingEditForm) {
			 ProductFormView(intent: .update(product))
				.environment(viewModel)
		  }
    }
}
