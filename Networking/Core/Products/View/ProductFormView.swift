//
//  NewProductView.swift
//  AdvancedNetworking
//
//  Created by Stephan Dowless on 2/23/26.
//

import SwiftUI

struct ProductFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ProductsViewModel.self) private var viewModel
    
    let intent: ProductFormIntent
    
    @State private var title = ""
    @State private var price = ""
    @State private var productDescription = ""
    @State private var categoryId = "1"
    @State private var imageURL = "https://picsum.photos/200/200"
    @State private var isSubmitting = false
    @State private var validationMessage: String?
    @State private var hasPopulatedFromIntent = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basics") {
                    TextField("Title", text: $title)
                    
                    TextField("Price", text: $price)
                        .keyboardType(.numberPad)
                    
                    TextField("Description", text: $productDescription, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Metadata") {
                    TextField("Category ID", text: $categoryId)
                        .keyboardType(.numberPad)
                    
                    TextField("Image URL", text: $imageURL)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                if let validationMessage {
                    Section {
                        Text(validationMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
            }
            .interactiveDismissDisabled(isSubmitting)
            .onAppear {
                populateFormIfNeeded()
            }
            .navigationTitle(intent.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .disabled(isSubmitting)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button { Task { await submit() } } label: {
                        HStack(spacing: 8) {
                            Text(intent.submitTitle)
                        }
                    }
                    .disabled(isSubmitting)
                }
            }
        }
    }
    
    private func submit() async {
        validationMessage = nil
        
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            validationMessage = "Title is required."
            return
        }
        
        guard let parsedPrice = Int(price), parsedPrice > 0 else {
            validationMessage = "Enter a valid price."
            return
        }
        
        guard let parsedCategoryId = Int(categoryId), parsedCategoryId > 0 else {
            validationMessage = "Enter a valid category ID."
            return
        }
        
        guard !productDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            validationMessage = "Description is required."
            return
        }
        
        guard !imageURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            validationMessage = "Image URL is required."
            return
        }
        
        isSubmitting = true
        defer { isSubmitting = false }
        
        switch intent {
        case .create:
			 let product = CreateProductRequest(
				title: title,
				price: parsedPrice,
				description: productDescription,
				categoryId: parsedCategoryId,
				images: [imageURL]
			 )
			 
			 await viewModel.createProduct(product)
            
			 dismiss()
        case .update(let product):
            print("Update product \(product.id)")
        }
    }
    
    private func populateFormIfNeeded() {
        guard !hasPopulatedFromIntent else { return }
        hasPopulatedFromIntent = true
        
        guard case .update(let product) = intent else { return }
        
        title = product.title
        price = String(product.price)
        productDescription = product.description
        categoryId = String(product.category?.id ?? 1)
        imageURL = product.images.first ?? "https://placehold.co/600x400"
    }
}
