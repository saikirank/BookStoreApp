import SwiftUI

struct HomeView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @StateObject private var catalogueVM = CatalogueViewModel()
    @State private var selectedBook: Book? = nil
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Hero Banner
                    heroBanner
                    
                    // Category Quick Access
                    categorySection
                    
                    // Recommended
                    if !cartViewModel.orders.isEmpty {
                        sectionHeader("Recommended For You", icon: "sparkles")
                        horizontalBookList(catalogueVM.recommendedBooks(basedOnOrders: cartViewModel.orders))
                    }
                    
                    // Featured Books
                    sectionHeader("Featured Books", icon: "flame.fill")
                    horizontalBookList(Array(catalogueVM.allBooks.prefix(6)))
                    
                    // Best Sellers
                    sectionHeader("Bestsellers", icon: "star.fill")
                    horizontalBookList(catalogueVM.allBooks.sorted { $0.reviewCount > $1.reviewCount }.prefix(6).map { $0 })
                    
                    Spacer(minLength: 20)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("BookHaven")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CartView()) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "cart").font(.title3)
                            if cartViewModel.itemCount > 0 {
                                Text("\(cartViewModel.itemCount)")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(3)
                                    .background(Color(hex: "e94560"))
                                    .clipShape(Circle())
                                    .offset(x: 8, y: -8)
                            }
                        }
                    }
                }
            }
            .sheet(item: $selectedBook) { book in
                ProductDetailView(book: book)
                    .environmentObject(cartViewModel)
            }
        }
    }
    
    var heroBanner: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [Color(hex: "0f3460"), Color(hex: "e94560")],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack(alignment: .leading, spacing: 8) {
                Text("Summer Reading")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
                Text("Up to 40% off\nBestsellers")
                    .font(.title.bold())
                    .foregroundColor(.white)
                Button(action: {}) {
                    Text("Shop Now →")
                        .font(.subheadline.bold())
                        .foregroundColor(Color(hex: "0f3460"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(20)
                }
            }
            .padding(20)
            
            Image(systemName: "books.vertical.fill")
                .font(.system(size: 100))
                .foregroundColor(.white.opacity(0.15))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.trailing, 20)
        }
        .frame(height: 180)
        .cornerRadius(20)
        .padding(.horizontal)
    }
    
    var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Browse Categories", icon: "square.grid.2x2.fill")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(BookCategory.allCases) { cat in
                        NavigationLink(destination: CatalogueView(initialCategory: cat)) {
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(categoryColor(for: cat).opacity(0.15))
                                        .frame(width: 56, height: 56)
                                    Image(systemName: cat.icon)
                                        .font(.title2)
                                        .foregroundColor(categoryColor(for: cat))
                                }
                                Text(cat.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 72)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    func sectionHeader(_ title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon).foregroundColor(Color(hex: "e94560"))
            Text(title).font(.headline)
            Spacer()
            Text("See all").font(.caption).foregroundColor(Color(hex: "e94560"))
        }
        .padding(.horizontal)
    }
    
    func horizontalBookList(_ books: [Book]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(books) { book in
                    BookCardView(book: book)
                        .onTapGesture { selectedBook = book }
                }
            }
            .padding(.horizontal)
        }
    }
    
    func categoryColor(for cat: BookCategory) -> Color {
        switch cat {
        case .fiction: return .blue
        case .nonFiction: return .green
        case .science: return .purple
        case .history: return .orange
        case .selfHelp: return .pink
        case .technology: return .teal
        case .romance: return .red
        case .mystery: return .indigo
        }
    }
}

// MARK: - Book Card
struct BookCardView: View {
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                LinearGradient(colors: [Color.random(seed: book.id), Color.random(seed: book.id + "2")],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                Image(systemName: book.coverImage)
                    .font(.system(size: 36))
                    .foregroundColor(.white.opacity(0.9))
            }
            .frame(width: 140, height: 190)
            .cornerRadius(12)
            
            Text(book.title)
                .font(.caption.bold())
                .lineLimit(2)
                .frame(width: 140, alignment: .leading)
            
            Text(book.author)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill").font(.system(size: 10)).foregroundColor(.yellow)
                Text("\(book.rating, specifier: "%.1f")")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Text("$\(book.price, specifier: "%.2f")")
                .font(.subheadline.bold())
                .foregroundColor(Color(hex: "e94560"))
        }
        .frame(width: 140)
    }
}

extension Color {
    static func random(seed: String) -> Color {
        let palette: [Color] = [
            Color(hex: "667eea"), Color(hex: "f093fb"), Color(hex: "4facfe"),
            Color(hex: "43e97b"), Color(hex: "fa709a"), Color(hex: "a18cd1"),
            Color(hex: "fccb90"), Color(hex: "84fab0"), Color(hex: "a1c4fd"),
            Color(hex: "fd746c"), Color(hex: "11998e"), Color(hex: "6a3093")
        ]
        let index = abs(seed.hashValue) % palette.count
        return palette[index]
    }
}

#Preview {
    HomeView()
        .environmentObject(CartViewModel())
}

#Preview("Book Card") {
    HStack {
        BookCardView(book: SampleData.books[0])
        BookCardView(book: SampleData.books[1])
    }
    .padding()
}
