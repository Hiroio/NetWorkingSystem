//
//  ContentView.swift
//  AdvancedNetworkingTutorial
//
//  Created by Stephan Dowless on 3/9/26.
//

import SwiftUI

enum MainMenu {
  case products, users
}

struct ContentView: View {
  @State private var tabNavigation: MainMenu = .products
    var body: some View {
		TabView(selection: $tabNavigation) {
		  ProductsView()
			 .tag(MainMenu.products)
			 .tabItem {
				Image(systemName: "rectangle.grid.1x2.fill")
				Text("Users")
			 }
		  UserListView()
			 .tag(MainMenu.users)
			 .tabItem {
				Image(systemName: "person.fill")
				Text("Users")
			 }
		}
    }
}

#Preview {
    ContentView()
}
