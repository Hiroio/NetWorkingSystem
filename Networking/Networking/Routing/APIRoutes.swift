//
//  APIRoutes.swift
//  Networking
//
//  Created by user on 17.05.2026.
//

import Foundation

struct URLConstants{
  static let url = URL(string: "https://api.escuelajs.co/api/v1")!
}

enum APIRoutes{
  case products(ProductEndpointsPath)
  case users(UserEndpoint)
  
  var path: String {
	 switch self {
	 case .products(let product):
		return product.path
	 case .users(let user):
		return user.path
	 }
  }
}
