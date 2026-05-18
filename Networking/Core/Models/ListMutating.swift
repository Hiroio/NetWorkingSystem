//
//  ListMutating.swift
//  Networking
//
//  Created by user on 18.05.2026.
//

import Foundation

protocol ListMutating: AnyObject{
  associatedtype Item: Identifiable, Decodable
  
  var loadingState: LoadingState<[Item]> {get set }
  
}


extension ListMutating{
  //  MARK: Helpers
	 func insertOrStart(with item: Item){
		switch loadingState {
		  case .loaded(var items):
		  items.insert(item, at: 0)
		  loadingState = .loaded(items)
		default:
		  loadingState = .loaded([item])
		}
	 }
	 
	 func replaceifLoaded(with item: Item){
		guard case .loaded(var items) = loadingState else {
		  return
		}
		
		guard let index = items.firstIndex(where: {$0.id == item.id}) else {
		  return
		}
		
		items[index] = item
		loadingState = .loaded(items)
	 }
	 
	 func removeifLoaded(id: Int){
		guard case .loaded(var items) = loadingState else {
		  return
		}
		guard let index = items.firstIndex(where: {$0.id as? Int == id}) else {
		  return
		}
		
		items.remove(at: index)
		loadingState = .loaded(items)
	 }
}
