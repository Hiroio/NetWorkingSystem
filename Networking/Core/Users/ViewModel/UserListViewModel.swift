import Foundation
import Observation

@MainActor
@Observable
final class UserListViewModel {
    var users: [User] = []

  let service: UserServiceProtocol
  
  init(service: UserServiceProtocol){
	 self.service = service
  }
  
    func loadUsers() async {
		do {
		  let fetchedUsers = try await service.fetchUsers()
		  self.users = fetchedUsers
		} catch {
		  print("Failed to fetch users, error: \(error)")
		}
    }

    func createUser(_ payload: CreateUserRequest) async {
		do {
		  let newUser = try await service.createUser(payload)
		  
		  users.insert(newUser, at: 0)
		} catch {
		  print("Failed to create users, error: \(error)")
		}
    }

    func updateUser(id: Int, payload: UpdateUserRequest) async {
		guard let index = users.firstIndex(where: {$0.id == id})else{ return }
		do {
		  let updatedUser = try await service.updateUser(id, with: payload)
		  users[index] = updatedUser
		} catch {
		  print("Failed to update users, error: \(error)")
		}
    }
    
  func deleteUser(id: Int) async {
	 guard let index = users.firstIndex(where: {$0.id == id})else{ return }
	 do {
		try await service.delete(id)
		users.remove(at: index)
	 } catch {
		print("Failed to delete users, error: \(error)")
	 }
  }
  
  func checkEmailAviability(email: String) async -> Bool {
	 do{
		let payload = CheckEmailAvailabilityRequest(email: email)
		return try await service.checkAvailability(payload)
	 }catch{
		print("Failed to check email aviability, error: \(error)")
	 }
	 return false
  }
  
  
}
