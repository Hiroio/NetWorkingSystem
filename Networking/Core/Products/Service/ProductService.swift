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
  let client: APIClient
  
  init(){
	 client = APIClient(baseURL: URLConstants.url)
  }
  
  // MARK:  - Fetching -GET-
  func fetchProducts() async throws -> [Product] {
	 let requestModel = APIRequests<[Product]>(method: .get, path: .products(.list))
	 return try await client.execute(requestModel)
  }
  
  // MARK: - Creation -POST-
  func createProduct(_ payload: CreateProductRequest) async throws -> Product {
	 let requestModel = try APIRequests<Product>(method: .post, path: .products(.list), body: payload)
	 return try await client.execute(requestModel)
  }
  
  // MARK: -Updating -PUT-
  func updateProduct(_ id: Int, with payload: UpdateProductRequest) async throws -> Product {
	 let requestModel = try APIRequests<Product>(method: .put, path: .products(.byID(id)), body: payload)
	 return try await client.execute(requestModel)
  }
  
  // MARK: -DELETING -Delete-
  func delete(_ id: Int) async throws {
	 let requestModel = APIRequests<EmptyResponse>(method: .delete, path: .products(.byID(id)))
	 try await client.execute(requestModel)
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

