import SwiftUI

struct CatalogueView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @StateObject private var vm = CatalogueViewModel()
    @State private var selectedBook: Book? = nil
    var initialCategory: BookCategory? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                    TextField("Search books, authors...", text: $vm.searchText)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(label: "All", isSelected: vm.selectedCategory == nil) {
                            vm.selectedCategory = nil
                        }
                        ForEach(BookCategory.allCases) { cat in
                            FilterChip(label: cat.rawValue, isSelected: vm.selectedCategory == cat) {
                                vm.selectedCategory = vm.selectedCategory == cat ? nil : cat
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
                
                // Brand + Sort row
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(label: "All Brands", isSelected: vm.selectedBrand == nil) {
                                vm.selectedBrand = nil
                            }
                            ForEach(vm.brands, id: \.self) { brand in
                                FilterChip(label: brand, isSelected: vm.selectedBrand == brand) {
                                    vm.selectedBrand = vm.selectedBrand == brand ? nil : brand
                                }
                            }
                        }
                    }
                    Spacer()
                    Menu {
                        ForEach(CatalogueViewModel.SortOption.allCases, id: \.self) { opt in
                            Button(opt.rawValue) { vm.sortOption = opt }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                            .font(.caption)
                            .foregroundColor(Color(hex: "e94560"))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                // Results count
                Text("\(vm.filteredBooks.count) books found")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 4)
                
                // Grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(vm.filteredBooks) { book in
                            CatalogueBookCard(book: book)
                                .onTapGesture { selectedBook = book }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Browse Books")
            .sheet(item: $selectedBook) { book in
                ProductDetailView(book: book)
                    .environmentObject(cartViewModel)
            }
            .onAppear {
                if let cat = initialCategory { vm.selectedCategory = cat }
            }
        }
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color(hex: "e94560") : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct CatalogueBookCard: View {
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                ZStack {
                    LinearGradient(colors: [Color.random(seed: book.id), Color.random(seed: book.id + "2")],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                    Image(systemName: book.coverImage)
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.85))
                }
                .frame(height: 160)
                .cornerRadius(12)
                
                if let originalPrice = book.originalPrice {
                    let discount = Int(((originalPrice - book.price) / originalPrice) * 100)
                    Text("-\(discount)%")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(hex: "e94560"))
                        .cornerRadius(6)
                        .padding(6)
                }
                
                if !book.inStock {
                    Text("Out of Stock")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.8))
                        .cornerRadius(6)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        .padding(6)
                }
            }
            
            Text(book.title)
                .font(.caption.bold())
                .lineLimit(2)
            Text(book.author)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            HStack {
                HStack(spacing: 2) {
                    Image(systemName: "star.fill").font(.system(size: 9)).foregroundColor(.yellow)
                    Text("\(book.rating, specifier: "%.1f")").font(.caption2)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 0) {
                    Text("$\(book.price, specifier: "%.2f")")
                        .font(.caption.bold())
                        .foregroundColor(Color(hex: "e94560"))
                    if let orig = book.originalPrice {
                        Text("$\(orig, specifier: "%.2f")")
                            .font(.system(size: 9))
                            .strikethrough()
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    CatalogueView()
        .environmentObject(CartViewModel())
}

#Preview("Catalogue Book Card") {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
        ForEach(SampleData.books.prefix(4)) { book in
            CatalogueBookCard(book: book)
        }
    }
    .padding()
}

#Preview("Filter Chip") {
    HStack {
        FilterChip(label: "Fiction", isSelected: true) {}
        FilterChip(label: "Science", isSelected: false) {}
        FilterChip(label: "All", isSelected: false) {}
    }
    .padding()
}
