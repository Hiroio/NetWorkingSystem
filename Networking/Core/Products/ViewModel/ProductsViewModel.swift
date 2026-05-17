//
//  ProductsViewModel.swift
//  AdvancedNetworkingTutorial
//
//  Created by Stephan Dowless on 3/9/26.
//

import Foundation

@Observable @MainActor
final class ProductsViewModel {
  var loadingState: LoadingState<[Product]> = .idle
  
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
	 do {
		let newProduct = try await service.createProduct(payload)
		insertOrStartProducts(with: newProduct)
		
		
	 } catch {
		loadingState = .error(error.localizedDescription)
		print("DEBUG: Failed to create products with error: \(error)")
	 }
  }
  
  //  MARK: - UPDATE Product
  func updateProduct(_ id: Int, with payload: UpdateProductRequest) async{
	 do {
		let newProduct = try await service.updateProduct(id, with: payload)
		replaceProductifLoaded(with: newProduct)
	 } catch {
		print("DEBUG: Failed to update products with error: \(error)")
	 }
  }
  
  func deleteProduct(_ id: Int) async {
	 do {
		try await service.delete(id)

		removeProductifLoaded(id: id)

	 } catch {
		print("DEBUG: Failed to delete products with error: \(error)")
	 }
  }
  
  
  private func insertOrStartProducts(with product: Product){
	 switch loadingState {
		case .loaded(var products):
		products.insert(product, at: 0)
		loadingState = .loaded(products)
	 default:
		loadingState = .loaded([product])
	 }
  }
  
  private func replaceProductifLoaded(with product: Product){
	 guard case .loaded(var products) = loadingState else {
		return
	 }
	 
	 guard let index = products.firstIndex(where: {$0.id == product.id}) else {
		return
	 }
	 
	 products[index] = product
	 loadingState = .loaded(products)
  }
  
  private func removeProductifLoaded(id: Int){
	 guard case .loaded(var products) = loadingState else {
		return
	 }
	 guard let index = products.firstIndex(where: {$0.id == id}){
		return
	 }
	 
	 products.remove(at: index)
	 loadingState = .loaded(products)
  }
}



