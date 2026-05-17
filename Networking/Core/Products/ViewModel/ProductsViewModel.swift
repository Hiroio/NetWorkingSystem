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
  
// MARK: - Creation
  func createProduct(_ payload: CreateProductRequest) async {
	 do {
		let newProduct = try await service.createProduct(payload)
		print("new product: \(newProduct)")
		
		products.insert(newProduct, at: 0)
	 } catch {
		print("DEBUG: Failed to create products with error: \(error)")
	 }
  }
}



