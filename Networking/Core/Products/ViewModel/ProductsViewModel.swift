//
//  ProductsViewModel.swift
//  AdvancedNetworkingTutorial
//
//  Created by Stephan Dowless on 3/9/26.
//

import Foundation

@Observable
final class ProductsViewModel {
  var products: [Product] = []
  
  private let service: ProductServiceProtocol
  
  init(service: ProductServiceProtocol) {
	 self.service = service
  }
  
  //  MARK: - Fetching
  func loadProducts() async {
	 do {
		self.products = try await service.fetchProducts()
	 } catch {
		print("DEBUG: Failed to fetch products with error: \(error)")
	 }
  }
  
  // MARK: - Creation Product
  func createProduct(_ payload: CreateProductRequest) async {
	 do {
		let newProduct = try await service.createProduct(payload)
		print("new product: \(newProduct)")
		
		products.insert(newProduct, at: 0)
	 } catch {
		print("DEBUG: Failed to create products with error: \(error)")
	 }
  }
  
  //  MARK: - UPDATE Product
  func updateProduct(_ id: Int, with payload: UpdateProductRequest) async{
	 guard let index = products.firstIndex(where: {$0.id == id}) else { return }
	 do {
		let newProduct = try await service.updateProduct(id, with: payload)
		print("Updated product: \(newProduct)")

		products[index] = newProduct
	 } catch {
		print("DEBUG: Failed to update products with error: \(error)")
	 }
  }
  
  func deleteProduct(_ id: Int) async {
	 guard let index = products.firstIndex(where: {$0.id == id}) else { return }
	 do {
		try await service.delete(id)

		products.remove(at: index)
	 } catch {
		print("DEBUG: Failed to delete products with error: \(error)")
	 }
  }
}



