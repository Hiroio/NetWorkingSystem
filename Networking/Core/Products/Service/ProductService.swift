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
  
  func updateProduct(_ id: Int, with payload: UpdateProductRequest) async throws -> Product
  
  func delete(_ id: Int) async throws
}


// MARK: Working Functional Service
struct ProductService: ProductServiceProtocol{
  
  private let url = URL(string: "https://api.escuelajs.co/api/v1/")!
  
  // MARK:  - Fetching
  func fetchProducts() async throws -> [Product] {
	 let requestModel = APIRequests<[Product]>(method: .get, path: "products")
	 return try await execute(requestModel)
  }
  
  // MARK: - Creation -POST-
  func createProduct(_ payload: CreateProductRequest) async throws -> Product {
	 let requestModel = try APIRequests<Product>(method: .post, path: "products", body: payload)
	 return try await execute(requestModel)
  }
  
  // MARK: -Updating -PUT-
  func updateProduct(_ id: Int, with payload: UpdateProductRequest) async throws -> Product {
	 let requestModel = try APIRequests<Product>(method: .put, path: "products/\(id)", body: payload)
	 return try await execute(requestModel)
  }
  
  //  -DELETING
  func delete(_ id: Int) async throws {
	 let requestModel = APIRequests<EmptyResponse>(method: .delete, path: "products/\(id)")
	 try await execute(requestModel)
  }
  
  @discardableResult
  private func execute<Responce>(_ requestModel: APIRequests<Responce>) async throws -> Responce{
	 let request = try requestModel.makeURLRequest(baseURL: url)
	 
	 let (data, response) = try await URLSession.shared.data(for: request)
	 
	 guard let httpResponse = response as? HTTPURLResponse else{
		throw URLError(.badServerResponse)
	 }
	 
	 guard 200..<300 ~= httpResponse.statusCode else{
		let bodyString = String(data: data, encoding: .utf8) ?? "Non UTF8 data"
		print("Update failed \(httpResponse.statusCode) - \(bodyString)")
		throw URLError(.badServerResponse)
	 }
	 
	 return try JSONDecoder().decode(Responce.self, from: data)
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
  
  func updateProduct(_ id: Int, with payload: UpdateProductRequest) async throws -> Product {
	 Product.mockProducts.first!
  }
  
  func delete(_ id: Int) async throws {
	 
  }
}

