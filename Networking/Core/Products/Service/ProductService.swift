//
//  ProductService.swift
//  Networking
//
//  Created by user on 17.05.2026.
//

import Foundation

protocol ProductServiceProtocol{
  func fetchProducts() async throws -> [Product]
  
  func createProduct(_ payload: CreateProductRequest) async throws -> Product
}


// MARK: Working Functional Service
struct ProductService: ProductServiceProtocol{
  
  private let url = URL(string: "https://api.escuelajs.co/api/v1/products")!
  
//  - Fetching
  func fetchProducts() async throws -> [Product] {
	 let (data, responce) = try await URLSession.shared.data(from: url)
	 
	 guard let httpResponse = responce as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else{
		throw URLError(.badServerResponse)
	 }
	 
	 
	 return try JSONDecoder().decode([Product].self, from: data)
  }
  
//  - Creation -POST-
  func createProduct(_ payload: CreateProductRequest) async throws -> Product {
	 var request = URLRequest(url: url)
	 request.httpMethod = "POST"
	 
	 let body = try JSONEncoder().encode(payload)
	 request.httpBody = body
	 request.setValue("application/json", forHTTPHeaderField: "Content-Type")
	 
	 let (data, response) = try await URLSession.shared.data(for: request)
	 guard let httpResponse = response as? HTTPURLResponse else{
		throw URLError(.badServerResponse)
	 }
	 
	 guard 200..<300 ~= httpResponse.statusCode else{
		let bodyString = String(data: data, encoding: .utf8) ?? "Non UTF8 data"
		print("Creation failed \(httpResponse.statusCode) - \(bodyString)")
		throw URLError(.badServerResponse)
	 }
	 
	 
	 return try JSONDecoder().decode(Product.self, from: data)
  }
}


// MARK: MOCK Service
struct MockProductService: ProductServiceProtocol{
  func fetchProducts() async throws -> [Product] {
	 return Product.mockProducts
  }
  
  
  func createProduct(_ payload: CreateProductRequest) async throws -> Product {
	 return Product.mockProducts.first!
  }
}

