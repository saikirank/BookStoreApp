import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.dismiss) var dismiss
    let book: Book
    @State private var addedToCart = false
    @State private var quantity = 1
    @StateObject private var catalogueVM = CatalogueViewModel()
    
    var relatedBooks: [Book] { catalogueVM.relatedBooks(for: book) }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Hero Image
                    ZStack {
                        LinearGradient(colors: [Color.random(seed: book.id), Color.random(seed: book.id + "2")],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                        VStack {
                            Image(systemName: book.coverImage)
                                .font(.system(size: 80))
                                .foregroundColor(.white.opacity(0.9))
                                .shadow(radius: 10)
                        }
                    }
                    .frame(height: 260)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Title & Author
                        VStack(alignment: .leading, spacing: 4) {
                            Text(book.category.rawValue)
                                .font(.caption)
                                .foregroundColor(Color(hex: "e94560"))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color(hex: "e94560").opacity(0.1))
                                .cornerRadius(6)
                            
                            Text(book.title)
                                .font(.title2.bold())
                            
                            Text("by \(book.author)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        // Rating & Reviews
                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                ForEach(0..<5) { i in
                                    Image(systemName: Double(i) < book.rating ? "star.fill" : "star")
                                        .font(.system(size: 14))
                                        .foregroundColor(.yellow)
                                }
                                Text("\(book.rating, specifier: "%.1f")")
                                    .font(.subheadline.bold())
                                Text("(\(book.reviewCount.formatted()) reviews)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Price
                        HStack(alignment: .bottom, spacing: 8) {
                            Text("$\(book.price, specifier: "%.2f")")
                                .font(.title.bold())
                                .foregroundColor(Color(hex: "e94560"))
                            if let orig = book.originalPrice {
                                Text("$\(orig, specifier: "%.2f")")
                                    .strikethrough()
                                    .foregroundColor(.secondary)
                                Text("Save \(Int(((orig - book.price) / orig) * 100))%")
                                    .font(.caption.bold())
                                    .foregroundColor(.green)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                        
                        Divider()
                        
                        // Delivery
                        HStack {
                            Image(systemName: "shippingbox.fill").foregroundColor(.green)
                            VStack(alignment: .leading) {
                                Text("Estimated Delivery").font(.caption).foregroundColor(.secondary)
                                Text(book.deliveryDate).font(.subheadline.bold()).foregroundColor(.green)
                            }
                            Spacer()
                            Image(systemName: book.inStock ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(book.inStock ? .green : .red)
                            Text(book.inStock ? "In Stock" : "Out of Stock")
                                .font(.caption.bold())
                                .foregroundColor(book.inStock ? .green : .red)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        // Description
                        VStack(alignment: .leading, spacing: 6) {
                            Text("About this book").font(.headline)
                            Text(book.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineSpacing(4)
                        }
                        
                        // Publisher
                        HStack {
                            Label(book.brand, systemImage: "building.2").font(.caption).foregroundColor(.secondary)
                        }
                        
                        Divider()
                        
                        // Quantity
                        HStack {
                            Text("Quantity").font(.subheadline.bold())
                            Spacer()
                            HStack(spacing: 16) {
                                Button(action: { if quantity > 1 { quantity -= 1 } }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(quantity > 1 ? Color(hex: "e94560") : .gray)
                                }
                                Text("\(quantity)").font(.headline.bold()).frame(width: 30)
                                Button(action: { quantity += 1 }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(Color(hex: "e94560"))
                                }
                            }
                        }
                        
                        // Add to Cart
                        Button(action: {
                            for _ in 0..<quantity { cartViewModel.addToCart(book) }
                            addedToCart = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { dismiss() }
                        }) {
                            HStack {
                                Image(systemName: addedToCart ? "checkmark.circle.fill" : "cart.badge.plus")
                                Text(addedToCart ? "Added to Cart!" : "Add to Cart — $\(book.price * Double(quantity), specifier: "%.2f")")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(book.inStock ? (addedToCart ? Color.green : Color(hex: "e94560")) : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                        }
                        .disabled(!book.inStock || addedToCart)
                        
                        // Related Books
                        if !relatedBooks.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Related Books").font(.headline)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(relatedBooks) { related in
                                            BookCardView(book: related)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    ProductDetailView(book: SampleData.books[0])
        .environmentObject(CartViewModel())
}

#Preview("Out of Stock Book") {
    ProductDetailView(book: SampleData.books[6])
        .environmentObject(CartViewModel())
}
