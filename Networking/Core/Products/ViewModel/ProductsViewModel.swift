//
//  ProductsViewModel.swift
//  AdvancedNetworkingTutorial
//
//  Created by Stephan Dowless on 3/9/26.
//

import Foundation

@Observable
final class ProductsViewModel: @MainActor ListMutating {
  var loadingState: LoadingState<[Product]> = .idle
  var mutationState: MutationState = .idle
  
  private let service: ProductServiceProtocol
  
  init(service: ProductServiceProtocol) {
	 self.service = service
  }
  
  //  MARK: - Fetching
  func loadProducts() async {
	 loadingState = .loading
	 do {
		let products = try await service.fetchProducts()
		loadingState = products.isEmpty ? .empty : .loaded(products)
	 } catch {
		loadingState = .error(error.localizedDescription)
		print("DEBUG: Failed to fetch products with error: \(error)")
	 }
  }
  
  // MARK: - Creation Product
  func createProduct(_ payload: CreateProductRequest) async {
	 mutationState = .inProgress(.create)
	 do {
		let newProduct = try await service.createProduct(payload)
		insertOrStart(with: newProduct)
		mutationState = .succeded(.create)
	 } catch {
		mutationState = .failed(.create, error.localizedDescription)
		print("DEBUG: Failed to create products with error: \(error)")
	 }
  }
  
  //  MARK: - UPDATE Product
  func updateProduct(_ id: Int, with payload: UpdateProductRequest) async{
	 mutationState = .inProgress(.update)
	 do {
		let newProduct = try await service.updateProduct(id, with: payload)
		replaceifLoaded(with: newProduct)
		mutationState = .succeded(.update)
	 } catch {
		mutationState = .failed(.update, error.localizedDescription)
		print("DEBUG: Failed to update products with error: \(error)")
	 }
  }
  
  func deleteProduct(_ id: Int) async {
	 mutationState = .inProgress(.delete)
	 do {
		try await service.delete(id)

		removeifLoaded(id: id)
		mutationState = .succeded(.delete)
	 } catch {
		mutationState = .failed(.delete, error.localizedDescription)
		print("DEBUG: Failed to delete products with error: \(error)")
	 }
  }
  
  func resetMutatingState() {
	 mutationState = .idle
  }
}



