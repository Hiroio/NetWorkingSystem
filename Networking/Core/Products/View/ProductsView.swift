import SwiftUI

@MainActor
struct ProductsView: View {
    @State private var viewModel = ProductsViewModel(service: ProductService())
    @State private var isShowingCreateSheet = false
    
    var body: some View {
        NavigationStack {
			 Group{
				switch viewModel.loadingState {
				case .idle, .loading:
				  ProgressView()
				case .empty:
				  Text("No Products to display")
				case .error(let errorMessage):
				  Text(errorMessage)
				case .loaded(let products):
				  ScrollView {
						LazyVStack(spacing: 16) {
							 ForEach(products) { product in
								  NavigationLink(value: product) {
										ProductCardView(product: product)
								  }
								  .buttonStyle(.plain)
							 }
						}
						.padding()
				  }
				}
			 }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingCreateSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
					 .environment(viewModel)
            }
            .sheet(isPresented: $isShowingCreateSheet) {
                ProductFormView(intent: .create)
                    .environment(viewModel)
            }
            .refreshable { await viewModel.loadProducts() }
            .task { await viewModel.loadProducts() }
        }
    }
}

#Preview {
    ProductsView()
}
