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
    
  @State private var isShowingMutationErrorAlert = false
  @State private var mutationErrorMessage = ""
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
				.alert("Couldn't save Product", isPresented: $isShowingMutationErrorAlert, actions: {
				  Button("Ok"){viewModel.resetMutatingState()}
				})
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
							 ZStack{
								if isSavingCurrentIntent{
								  ProgressView()
								}else{
								  Text(intent.submitTitle)
								}
							 }
                    }
                    .disabled(isSubmitting)
                }
            }
        }
    }
    
   
}



private extension ProductFormView{
  func submit() async {
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
		  let payload = CreateProductRequest(
			 title: title,
			 price: parsedPrice,
			 description: productDescription,
			 categoryId: parsedCategoryId,
			 images: [imageURL]
		  )
		  await viewModel.createProduct(payload)
		case .update(let product):
		  let payload = UpdateProductRequest(
			 title: title,
			 price: parsedPrice
		  )
		  await viewModel.updateProduct(product.id, with: payload)
		}
	 
	 switch viewModel.mutationState{
	 case .succeded(let operation) where operation == expectedMutatingOpertaion:
		guard operation == .create else { return }
		viewModel.resetMutatingState()
		dismiss()
	 case .failed(let operation, let errorMessage):
		mutationErrorMessage = errorMessage
		isShowingMutationErrorAlert = true
	 default:
		break
	 }
	 
  }
  
   func populateFormIfNeeded() {
		guard !hasPopulatedFromIntent else { return }
		hasPopulatedFromIntent = true
		
		guard case .update(let product) = intent else { return }
		
		title = product.title
		price = String(product.price)
		productDescription = product.description
		categoryId = String(product.category?.id ?? 1)
		imageURL = product.images.first ?? "https://placehold.co/600x400"
  }

var expectedMutatingOpertaion: MutationOperation{
  switch intent {
  case .create:
	 return .create
  case .update(let product):
	 return .update
  }
}
  
  var isSavingCurrentIntent: Bool{
	 guard case .inProgress(let operation) = viewModel.mutationState else { return false }
	 
	 return operation == expectedMutatingOpertaion
  }
}
