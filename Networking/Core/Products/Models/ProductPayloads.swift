//
//  ProductPayloads.swift
//  Networking
//
//  Created by user on 17.05.2026.
//

import Foundation

struct CreateProductRequest: Encodable{
  let title: String
  let price: Int
  let description: String
  let categoryId: Int
  let images: [String]
}
