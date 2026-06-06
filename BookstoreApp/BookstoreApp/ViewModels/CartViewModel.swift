import Foundation
import Combine

class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var orders: [Order] = []
    @Published var giftPointsRedeemed: Int = 0
    
    var itemCount: Int { items.reduce(0) { $0 + $1.quantity } }
    var subtotal: Double { items.reduce(0) { $0 + $1.total } }
    var pointsDiscount: Double { Double(giftPointsRedeemed) * 0.01 }
    var total: Double { max(0, subtotal - pointsDiscount) }
    
    func addToCart(_ book: Book) {
        if let idx = items.firstIndex(where: { $0.book.id == book.id }) {
            items[idx].quantity += 1
        } else {
            items.append(CartItem(book: book, quantity: 1))
        }
    }
    
    func removeFromCart(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
    }
    
    func updateQuantity(for item: CartItem, quantity: Int) {
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            if quantity <= 0 {
                items.remove(at: idx)
            } else {
                items[idx].quantity = quantity
            }
        }
    }
    
    func redeemPoints(_ points: Int, available: Int) {
        giftPointsRedeemed = min(points, available)
    }
    
    func placeOrder(address: DeliveryAddress, paymentMethod: PaymentMethod) -> Order {
        let order = Order(
            id: "ORD-\(Int.random(in: 100000...999999))",
            date: Date(),
            books: items,
            total: total,
            status: .processing,
            deliveryAddress: address,
            paymentMethod: paymentMethod
        )
        orders.insert(order, at: 0)
        items = []
        giftPointsRedeemed = 0
        return order
    }
    
    func cancelOrder(_ order: Order) {
        if let idx = orders.firstIndex(where: { $0.id == order.id }) {
            orders[idx] = Order(id: order.id, date: order.date, books: order.books, total: order.total, status: .cancelled, deliveryAddress: order.deliveryAddress, paymentMethod: order.paymentMethod)
        }
    }
}
