//
//  ProductEndpointsPath.swift
//  Networking
//
//  Created by user on 17.05.2026.
//

import Foundation


enum ProductEndpointsPath{
  case list
  case byID(Int)
  
  var path: String{
	 switch self {
	 case .list:
		"products"
	 case .byID(let id):
		"products/\(id)"
	 }
  }
}
