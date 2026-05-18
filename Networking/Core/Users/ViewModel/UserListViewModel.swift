import Foundation
import Observation


@Observable
final class UserListViewModel: @MainActor ListMutating {
  var loadingState: LoadingState<[User]> = .loading
  
  let service: UserServiceProtocol
  
  init(service: UserServiceProtocol){
	 self.service = service
  }
  
    func loadUsers() async {
		loadingState = .loading
		do {
		  let fetchedUsers = try await service.fetchUsers()
		  loadingState = fetchedUsers.isEmpty ? .empty : .loaded(fetchedUsers)
		} catch {
		  print("Failed to fetch users, error: \(error)")
		}
    }

    func createUser(_ payload: CreateUserRequest) async {
		do {
		  let newUser = try await service.createUser(payload)
		  insertOrStart(with: newUser)
		} catch {
		  loadingState = .error(error.localizedDescription)
		  print("Failed to create users, error: \(error)")
		}
    }

    func updateUser(id: Int, payload: UpdateUserRequest) async {
		do {
		  let updatedUser = try await service.updateUser(id, with: payload)
		  replaceifLoaded(with: updatedUser)
		} catch {
		  print("Failed to update users, error: \(error)")
		}
    }
    
  func deleteUser(id: Int) async {
	 do {
		try await service.delete(id)
		removeifLoaded(id: id)
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
