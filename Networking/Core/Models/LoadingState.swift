//
//  LoadingState.swift
//  Networking
//
//  Created by user on 17.05.2026.
//

import Foundation

enum LoadingState<Value: Decodable>{
  case idle
  case loading
  case empty
  case error(String)
  case loaded(Value)
}
