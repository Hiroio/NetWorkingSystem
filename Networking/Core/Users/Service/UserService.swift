//
//  UserService.swift
//  Networking
//
//  Created by user on 17.05.2026.
//

import Foundation

protocol UserServiceProtocol{
  func fetchUsers() async throws -> [User]
  func createUser(_ payload: CreateUserRequest) async throws -> User
  func updateUser(_ id: Int, with payload: UpdateUserRequest) async throws -> User
  func delete(_ id: Int) async throws
  func checkAvailability(_ payload: CheckEmailAvailabilityRequest) async throws -> Bool
}

struct UserService: UserServiceProtocol {
  let client: APIClient
  
  init() {
	 self.client = APIClient(baseURL: URLConstants.url)
  }
  
  func fetchUsers() async throws -> [User] {
	 let requestModel = APIRequests<[User]>(method: .get, path: .users(.list))
	 return try await client.execute(requestModel)
  }
  
  func createUser(_ payload: CreateUserRequest) async throws -> User {
	 let requestModel = try APIRequests<User>(method: .post, path: .users(.list), body: payload)
	 return try await client.execute(requestModel)
  }
  
  func updateUser(_ id: Int, with payload: UpdateUserRequest) async throws -> User {
	 let requestModel = try APIRequests<User>(method: .put, path: .users(.byID(id)), body: payload)
	 return try await client.execute(requestModel)
  }
  
  func delete(_ id: Int) async throws {
	 let requestModel = APIRequests<EmptyResponse>(method: .delete, path: .users(.byID(id)))
	 try await client.execute(requestModel)
  }
  
  func checkAvailability(_ payload: CheckEmailAvailabilityRequest) async throws -> Bool{
	 let requestModel = try APIRequests<CheckEmailAvailabilityResponse>(method: .post, path: .users(.emailAvailability), body: payload)
	 return try await client.execute(requestModel).isAvailable
  }
  
  
}
