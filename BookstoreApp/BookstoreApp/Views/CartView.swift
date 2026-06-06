import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var catalogueVM = CatalogueViewModel()
    @State private var navigateToCheckout = false
    
    var body: some View {
        NavigationView {
            Group {
                if cartViewModel.items.isEmpty {
                    emptyCartView
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Cart Items
                            ForEach(cartViewModel.items) { item in
                                CartItemRow(item: item)
                                    .environmentObject(cartViewModel)
                            }
                            
                            // Recommended
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "sparkles").foregroundColor(Color(hex: "e94560"))
                                    Text("Recommended").font(.headline)
                                }
                                .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(catalogueVM.recommendedBooks(basedOnOrders: cartViewModel.orders)) { book in
                                            VStack(alignment: .leading, spacing: 6) {
                                                ZStack {
                                                    LinearGradient(colors: [Color.random(seed: book.id), Color.random(seed: book.id + "2")], startPoint: .topLeading, endPoint: .bottomTrailing)
                                                    Image(systemName: book.coverImage).font(.system(size: 30)).foregroundColor(.white)
                                                }
                                                .frame(width: 100, height: 130).cornerRadius(10)
                                                Text(book.title).font(.caption.bold()).lineLimit(2).frame(width: 100, alignment: .leading)
                                                Text("$\(book.price, specifier: "%.2f")").font(.caption).foregroundColor(Color(hex: "e94560"))
                                                Button(action: { cartViewModel.addToCart(book) }) {
                                                    Text("Add").font(.caption2.bold()).foregroundColor(.white)
                                                        .padding(.horizontal, 12).padding(.vertical, 4)
                                                        .background(Color(hex: "e94560")).cornerRadius(6)
                                                }
                                            }
                                            .frame(width: 100)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical, 8)
                            
                            // Order Summary
                            orderSummary
                            
                            // Checkout Button
                            NavigationLink(destination: CheckoutView().environmentObject(cartViewModel).environmentObject(authViewModel), isActive: $navigateToCheckout) {
                                EmptyView()
                            }
                            
                            Button(action: { navigateToCheckout = true }) {
                                HStack {
                                    Text("Proceed to Checkout")
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text("$\(cartViewModel.total, specifier: "%.2f")")
                                        .fontWeight(.bold)
                                    Image(systemName: "arrow.right")
                                }
                                .padding()
                                .background(Color(hex: "e94560"))
                                .foregroundColor(.white)
                                .cornerRadius(14)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Shopping Cart")
        }
    }
    
    var emptyCartView: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart.badge.questionmark")
                .font(.system(size: 70))
                .foregroundColor(.secondary.opacity(0.5))
            Text("Your cart is empty").font(.title3.bold())
            Text("Add some books to get started!").font(.subheadline).foregroundColor(.secondary)
        }
    }
    
    var orderSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Summary").font(.headline)
            
            HStack { Text("Subtotal (\(cartViewModel.itemCount) items)"); Spacer(); Text("$\(cartViewModel.subtotal, specifier: "%.2f")") }
            HStack { Text("Shipping"); Spacer(); Text("FREE").foregroundColor(.green).fontWeight(.semibold) }
            if cartViewModel.giftPointsRedeemed > 0 {
                HStack {
                    Text("Gift Points (\(cartViewModel.giftPointsRedeemed) pts)")
                    Spacer()
                    Text("-$\(cartViewModel.pointsDiscount, specifier: "%.2f")").foregroundColor(.green)
                }
            }
            Divider()
            HStack {
                Text("Total").font(.headline)
                Spacer()
                Text("$\(cartViewModel.total, specifier: "%.2f")").font(.headline).foregroundColor(Color(hex: "e94560"))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(14)
        .padding(.horizontal)
    }
}

struct CartItemRow: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    let item: CartItem
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                LinearGradient(colors: [Color.random(seed: item.book.id), Color.random(seed: item.book.id + "2")], startPoint: .topLeading, endPoint: .bottomTrailing)
                Image(systemName: item.book.coverImage).font(.title2).foregroundColor(.white)
            }
            .frame(width: 70, height: 90).cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.book.title).font(.subheadline.bold()).lineLimit(2)
                Text(item.book.author).font(.caption).foregroundColor(.secondary)
                Text("$\(item.book.price, specifier: "%.2f")").font(.caption.bold()).foregroundColor(Color(hex: "e94560"))
                
                HStack(spacing: 12) {
                    Button(action: { cartViewModel.updateQuantity(for: item, quantity: item.quantity - 1) }) {
                        Image(systemName: "minus.circle.fill").foregroundColor(item.quantity > 1 ? Color(hex: "e94560") : .gray)
                    }
                    Text("\(item.quantity)").font(.subheadline.bold())
                    Button(action: { cartViewModel.updateQuantity(for: item, quantity: item.quantity + 1) }) {
                        Image(systemName: "plus.circle.fill").foregroundColor(Color(hex: "e94560"))
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Button(action: { cartViewModel.removeFromCart(item) }) {
                    Image(systemName: "trash").foregroundColor(.red).font(.caption)
                }
                Text("$\(item.total, specifier: "%.2f")").font(.subheadline.bold())
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}

#Preview("Cart with Items") {
    let cart = CartViewModel()
    cart.addToCart(SampleData.books[0])
    cart.addToCart(SampleData.books[1])
    cart.addToCart(SampleData.books[3])
    return CartView()
        .environmentObject(cart)
        .environmentObject(AuthViewModel())
}

#Preview("Empty Cart") {
    CartView()
        .environmentObject(CartViewModel())
        .environmentObject(AuthViewModel())
}

#Preview("Cart Item Row") {
    let cart = CartViewModel()
    cart.addToCart(SampleData.books[0])
    return CartItemRow(item: cart.items[0])
        .environmentObject(cart)
        .padding()
}
