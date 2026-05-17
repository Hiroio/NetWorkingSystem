//
//  UserListView.swift
//  AdvancedNetworking
//
//  Created by Stephan Dowless on 3/1/26.
//

import SwiftUI
import Kingfisher

struct UserListView: View {
    @State private var viewModel = UserListViewModel(service: UserService())
    @State private var hasLoaded = false
    @State private var formIntent: UserFormIntent?
    
    var body: some View {
        NavigationStack {
            List(viewModel.users) { user in
                UserRowView(user: user)
                    .padding(.vertical, 6)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Edit") {
                            formIntent = .update(user)
                        }
                        .tint(.blue)
                    }
            }
            .listStyle(.plain)
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        formIntent = .create
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        
        .refreshable { await viewModel.loadUsers() }
        .sheet(item: $formIntent) { intent in
            UserFormView(intent: intent)
                .environment(viewModel)
        }
        .task {
            guard !hasLoaded else { return }
            await viewModel.loadUsers()
            hasLoaded = true
        }
    }
}

#Preview {
    UserListView()
}
