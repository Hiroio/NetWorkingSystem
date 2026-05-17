//
//  APIClient.swift
//  Networking
//
//  Created by user on 17.05.2026.
//

import Foundation

struct APIClient {
  let baseURL: URL
  var session: URLSession = .shared
  var decoder: JSONDecoder = JSONDecoder()
  
  @discardableResult
  func execute<Responce>(_ requestModel: APIRequests<Responce>) async throws -> Responce{
	 do{
		let request = try requestModel.makeURLRequest(baseURL: baseURL)
		
		let (data, response) = try await session.data(for: request)
		
		guard let httpResponse = response as? HTTPURLResponse else{
		  throw NetworkError.invalidResponse
		}
		
		guard 200..<300 ~= httpResponse.statusCode else{
		  throw NetworkError.httpStatus(code: httpResponse.statusCode)
		}
		
		return try decoder.decode(Responce.self, from: data)
	 }catch{
		let mapped = NetworkErrorMapper.map(error)
		throw mapped
	 }
  }
}
