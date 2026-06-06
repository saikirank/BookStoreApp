import SwiftUI

struct OrderConfirmationView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.dismiss) var dismiss
    let order: Order
    @State private var showCancelAlert = false
    @State private var isCancelled = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Success Animation Area
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 120, height: 120)
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 95, height: 95)
                            Image(systemName: isCancelled ? "xmark.circle.fill" : "checkmark.circle.fill")
                                .font(.system(size: 54))
                                .foregroundColor(isCancelled ? .red : .green)
                        }
                        
                        Text(isCancelled ? "Order Cancelled" : "Order Confirmed!")
                            .font(.title.bold())
                        
                        Text(isCancelled ? "Your order has been cancelled and a refund is initiated." : "Thank you for your purchase! Your books are on the way.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        // Order ID
                        Text(order.id)
                            .font(.system(.body, design: .monospaced).bold())
                            .foregroundColor(Color(hex: "e94560"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(hex: "e94560").opacity(0.08))
                            .cornerRadius(8)
                    }
                    .padding(.top, 48)
                    
                    // Order Details Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Order Details").font(.headline)
                        
                        // Items
                        ForEach(order.books) { item in
                            HStack(spacing: 10) {
                                ZStack {
                                    LinearGradient(colors: [Color.random(seed: item.book.id), Color.random(seed: item.book.id + "2")], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    Image(systemName: item.book.coverImage).foregroundColor(.white)
                                }
                                .frame(width: 50, height: 65).cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(item.book.title).font(.caption.bold()).lineLimit(2)
                                    Text("Qty: \(item.quantity)").font(.caption2).foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("$\(item.total, specifier: "%.2f")").font(.caption.bold())
                            }
                        }
                        
                        Divider()
                        
                        // Total
                        HStack {
                            Text("Total Paid").font(.subheadline.bold())
                            Spacer()
                            Text("$\(order.total, specifier: "%.2f")").font(.subheadline.bold()).foregroundColor(Color(hex: "e94560"))
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Delivery Info
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Delivery Info").font(.headline)
                        
                        HStack {
                            Image(systemName: "location.fill").foregroundColor(Color(hex: "e94560"))
                            VStack(alignment: .leading) {
                                Text(order.deliveryAddress.name).font(.caption.bold())
                                Text(order.deliveryAddress.fullAddress).font(.caption).foregroundColor(.secondary)
                            }
                        }
                        
                        HStack {
                            Image(systemName: order.paymentMethod.icon).foregroundColor(Color(hex: "e94560"))
                            Text(order.paymentMethod.rawValue).font(.caption)
                        }
                        
                        HStack {
                            Image(systemName: "calendar").foregroundColor(Color(hex: "e94560"))
                            Text("Ordered on \(order.date.formatted(date: .abbreviated, time: .shortened))").font(.caption).foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Cancel within 48 hrs
                    if !isCancelled && order.canCancel {
                        Button(action: { showCancelAlert = true }) {
                            HStack {
                                Image(systemName: "xmark.circle")
                                Text("Cancel Order (within 48 hrs)")
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.08))
                            .foregroundColor(.red)
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.red.opacity(0.3), lineWidth: 1))
                        }
                        .padding(.horizontal)
                    }
                    
                    // Continue shopping
                    Button(action: { dismiss() }) {
                        Text("Continue Shopping")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "e94560"))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
        }
        .alert("Cancel Order?", isPresented: $showCancelAlert) {
            Button("Cancel Order", role: .destructive) {
                cartViewModel.cancelOrder(order)
                isCancelled = true
            }
            Button("Keep Order", role: .cancel) {}
        } message: {
            Text("Are you sure you want to cancel this order? You can only cancel within 48 hours of placing the order.")
        }
    }
}

#Preview {
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
    return OrderConfirmationView(order: order)
        .environmentObject(cart)
}
