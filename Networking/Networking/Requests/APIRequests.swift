//
//  APIRequests.swift
//  Networking
//
//  Created by user on 17.05.2026.
//

import Foundation



enum HTTPMethod: String{
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

struct EmptyResponse: Decodable {}

struct APIRequests<Responce: Decodable> {
  let method: HTTPMethod
  let path: APIRoutes
  var queryItems: [URLQueryItem]
  var headers: [String: String]
  var body: Data?
  
  init(
	 method: HTTPMethod,
	 path: APIRoutes,
	 queryItems: [URLQueryItem] = [],
	 headers: [String : String] = [:],
	 body: Data? = nil
  ) {
	 self.method = method
	 self.path = path
	 self.queryItems = queryItems
	 self.headers = headers
	 self.body = body
  }
  
  init<Body: Encodable>(
	 method: HTTPMethod,
	 path: APIRoutes,
	 queryItems: [URLQueryItem] = [],
	 headers: [String : String] = [:],
	 encoder: JSONEncoder = .init(),
	 body: Body
  ) throws{
	 self.method = method
	 self.path = path
	 self.queryItems = queryItems
	 self.headers = headers
	 self.body = try encoder.encode(body)
	 
	 if self.headers["Content-Type"] == nil {
		self.headers["Content-Type"] = "application/json"
	 }
  }
  
  func makeURLRequest(baseURL: URL, defaultHeader: [String: String] = [:]) throws -> URLRequest{
	 guard var components = URLComponents(url: baseURL.appendingPathComponent(path.path), resolvingAgainstBaseURL: true) else {
		throw URLError(.badURL)
	 }
	 
	 if !queryItems.isEmpty {
		components.queryItems = queryItems
	 }
	 
	 guard let url = components.url else {
		throw URLError(.badURL)
	 }
	 
	 var request = URLRequest(url: url)
	 request.httpMethod = method.rawValue
	 
	 var mergedHeaders = defaultHeader
	 mergedHeaders.merge(headers) { (_, new) in new }
	 
	 request.allHTTPHeaderFields = mergedHeaders
	 request.httpBody = body
	 
	 return request
  }
}


