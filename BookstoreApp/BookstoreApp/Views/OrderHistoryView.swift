import SwiftUI

struct OrderHistoryView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var catalogueVM = CatalogueViewModel()
    @State private var selectedOrder: Order? = nil
    
    var body: some View {
        NavigationView {
            Group {
                if cartViewModel.orders.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "list.bullet.rectangle")
                            .font(.system(size: 64))
                            .foregroundColor(.secondary.opacity(0.4))
                        Text("No orders yet").font(.title3.bold())
                        Text("Your order history will appear here").font(.subheadline).foregroundColor(.secondary)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Recommendations based on order history
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "sparkles").foregroundColor(Color(hex: "e94560"))
                                    Text("Based on Your Orders").font(.headline)
                                }
                                .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 14) {
                                        ForEach(catalogueVM.recommendedBooks(basedOnOrders: cartViewModel.orders)) { book in
                                            VStack(alignment: .leading, spacing: 4) {
                                                ZStack {
                                                    LinearGradient(colors: [Color.random(seed: book.id), Color.random(seed: book.id + "2")], startPoint: .topLeading, endPoint: .bottomTrailing)
                                                    Image(systemName: book.coverImage).font(.title2).foregroundColor(.white)
                                                }
                                                .frame(width: 90, height: 120).cornerRadius(10)
                                                Text(book.title).font(.caption.bold()).lineLimit(2).frame(width: 90, alignment: .leading)
                                                Text("$\(book.price, specifier: "%.2f")").font(.caption).foregroundColor(Color(hex: "e94560"))
                                                Button(action: { cartViewModel.addToCart(book) }) {
                                                    Text("Add to Cart").font(.system(size: 10, weight: .bold))
                                                        .foregroundColor(.white).padding(.horizontal, 8).padding(.vertical, 4)
                                                        .background(Color(hex: "e94560")).cornerRadius(6)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.top, 8)
                            
                            Divider().padding(.horizontal)
                            
                            Text("Your Orders").font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                            
                            ForEach(cartViewModel.orders) { order in
                                OrderCard(order: order)
                                    .environmentObject(cartViewModel)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("My Orders")
        }
    }
}

struct OrderCard: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    let order: Order
    @State private var showCancelAlert = false
    @State private var expanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(order.id).font(.caption.bold()).foregroundColor(Color(hex: "e94560"))
                    Text(order.date.formatted(date: .abbreviated, time: .omitted)).font(.caption2).foregroundColor(.secondary)
                }
                Spacer()
                StatusBadge(status: order.status)
            }
            
            // Books Preview
            HStack(spacing: 8) {
                ForEach(order.books.prefix(3)) { item in
                    ZStack {
                        LinearGradient(colors: [Color.random(seed: item.book.id), Color.random(seed: item.book.id + "2")], startPoint: .topLeading, endPoint: .bottomTrailing)
                        Image(systemName: item.book.coverImage).foregroundColor(.white).font(.caption)
                    }
                    .frame(width: 46, height: 60).cornerRadius(8)
                }
                if order.books.count > 3 {
                    ZStack {
                        Color(.systemGray5)
                        Text("+\(order.books.count - 3)").font(.caption.bold()).foregroundColor(.secondary)
                    }
                    .frame(width: 46, height: 60).cornerRadius(8)
                }
                Spacer()
                Text("$\(order.total, specifier: "%.2f")").font(.headline.bold()).foregroundColor(Color(hex: "e94560"))
            }
            
            // Actions
            HStack(spacing: 8) {
                // Buy Again
                Button(action: {
                    for item in order.books { cartViewModel.addToCart(item.book) }
                }) {
                    Label("Buy Again", systemImage: "cart.badge.plus")
                        .font(.caption.bold())
                        .foregroundColor(Color(hex: "e94560"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(hex: "e94560").opacity(0.08))
                        .cornerRadius(8)
                }
                
                // Track
                Button(action: { expanded.toggle() }) {
                    Label("Details", systemImage: expanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                // Cancel if eligible
                if order.canCancel && order.status != .cancelled {
                    Button(action: { showCancelAlert = true }) {
                        Text("Cancel")
                            .font(.caption.bold())
                            .foregroundColor(.red)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.red.opacity(0.08))
                            .cornerRadius(8)
                    }
                }
            }
            
            if expanded {
                Divider()
                VStack(alignment: .leading, spacing: 8) {
                    Text("Delivery: \(order.deliveryAddress.fullAddress)").font(.caption).foregroundColor(.secondary)
                    Text("Payment: \(order.paymentMethod.rawValue)").font(.caption).foregroundColor(.secondary)
                    ForEach(order.books) { item in
                        HStack {
                            Text("• \(item.book.title)").font(.caption).lineLimit(1)
                            Spacer()
                            Text("x\(item.quantity)  $\(item.total, specifier: "%.2f")").font(.caption).foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 2)
        .alert("Cancel Order?", isPresented: $showCancelAlert) {
            Button("Yes, Cancel", role: .destructive) { cartViewModel.cancelOrder(order) }
            Button("No", role: .cancel) {}
        }
    }
}

struct StatusBadge: View {
    let status: OrderStatus
    
    var statusColor: Color {
        switch status {
        case .processing: return .orange
        case .shipped: return .blue
        case .delivered: return .green
        case .cancelled: return .red
        }
    }
    
    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(statusColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.1))
            .cornerRadius(8)
    }
}

#Preview("With Orders") {
    let cart = CartViewModel()
    cart.addToCart(SampleData.books[0])
    cart.addToCart(SampleData.books[1])
    let _ = cart.placeOrder(address: SampleData.addresses[0], paymentMethod: .creditCard)
    cart.addToCart(SampleData.books[3])
    let _ = cart.placeOrder(address: SampleData.addresses[0], paymentMethod: .upi)
    return OrderHistoryView()
        .environmentObject(cart)
        .environmentObject(AuthViewModel())
}

#Preview("Empty Orders") {
    OrderHistoryView()
        .environmentObject(CartViewModel())
        .environmentObject(AuthViewModel())
}

#Preview("Order Card") {
    let cart = CartViewModel()
    cart.addToCart(SampleData.books[0])
    cart.addToCart(SampleData.books[2])
    let order = Order(
        id: "ORD-847291",
        date: Date(),
        books: cart.items,
        total: 27.98,
        status: .processing,
        deliveryAddress: SampleData.addresses[0],
        paymentMethod: .creditCard
    )
    return OrderCard(order: order)
        .environmentObject(cart)
        .padding()
}

#Preview("Status Badge") {
    HStack(spacing: 10) {
        StatusBadge(status: .processing)
        StatusBadge(status: .shipped)
        StatusBadge(status: .delivered)
        StatusBadge(status: .cancelled)
    }
    .padding()
}
