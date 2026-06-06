import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedAddress: DeliveryAddress? = nil
    @State private var selectedPayment: PaymentMethod = .creditCard
    @State private var pointsToRedeem: Double = 0
    @State private var showPaymentScreen = false
    @State private var placedOrder: Order? = nil
    @State private var showConfirmation = false
    
    var availablePoints: Int { authViewModel.currentUser?.giftPoints ?? 0 }
    var addresses: [DeliveryAddress] { authViewModel.currentUser?.addresses ?? SampleData.addresses }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Steps Indicator
                StepsIndicator(currentStep: showPaymentScreen ? 2 : 1)
                
                if !showPaymentScreen {
                    addressSection
                    Divider()
                    giftPointsSection
                    Divider()
                    orderSummaryMini
                    
                    Button(action: { showPaymentScreen = true }) {
                        Text("Continue to Payment")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedAddress != nil ? Color(hex: "e94560") : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                    .disabled(selectedAddress == nil)
                    .padding(.horizontal)
                } else {
                    paymentSection
                    Divider()
                    orderSummaryMini
                    
                    Button(action: placeOrder) {
                        HStack {
                            Image(systemName: "lock.fill")
                            Text("Place Order — $\(cartViewModel.total, specifier: "%.2f")")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "e94560"))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(showPaymentScreen ? "Payment" : "Delivery Address")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(showPaymentScreen)
        .toolbar {
            if showPaymentScreen {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showPaymentScreen = false }) {
                        Label("Back", systemImage: "chevron.left")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showConfirmation) {
            if let order = placedOrder {
                OrderConfirmationView(order: order)
                    .environmentObject(cartViewModel)
            }
        }
        .onAppear {
            selectedAddress = addresses.first(where: { $0.isDefault }) ?? addresses.first
        }
    }
    
    var addressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "location.fill").foregroundColor(Color(hex: "e94560"))
                Text("Delivery Address").font(.headline)
            }
            .padding(.horizontal)
            
            ForEach(addresses) { addr in
                AddressCard(address: addr, isSelected: selectedAddress?.id == addr.id)
                    .onTapGesture { selectedAddress = addr }
            }
            .padding(.horizontal)
            
            Button(action: {}) {
                Label("Add New Address", systemImage: "plus.circle")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "e94560"))
            }
            .padding(.horizontal)
        }
    }
    
    var giftPointsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "gift.fill").foregroundColor(Color(hex: "e94560"))
                Text("Gift Points").font(.headline)
                Spacer()
                Text("\(availablePoints) pts available").font(.caption).foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            VStack(spacing: 8) {
                HStack {
                    Text("Redeem Points").font(.subheadline)
                    Spacer()
                    Text("\(Int(pointsToRedeem)) pts = $\(Int(pointsToRedeem) / 100, specifier: "%d").\(Int(pointsToRedeem) % 100 < 10 ? "0\(Int(pointsToRedeem) % 100)" : "\(Int(pointsToRedeem) % 100)")")
                        .font(.caption).foregroundColor(Color(hex: "e94560"))
                }
                Slider(value: $pointsToRedeem, in: 0...Double(min(availablePoints, Int(cartViewModel.subtotal * 100))), step: 50)
                    .accentColor(Color(hex: "e94560"))
                    .onChange(of: pointsToRedeem) { val in
                        cartViewModel.redeemPoints(Int(val), available: availablePoints)
                    }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    var paymentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "creditcard.fill").foregroundColor(Color(hex: "e94560"))
                Text("Payment Method").font(.headline)
            }
            .padding(.horizontal)
            
            ForEach(PaymentMethod.allCases, id: \.self) { method in
                PaymentOptionRow(method: method, isSelected: selectedPayment == method)
                    .onTapGesture { selectedPayment = method }
                    .padding(.horizontal)
            }
        }
    }
    
    var orderSummaryMini: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Order Summary").font(.headline).padding(.horizontal)
            
            VStack(spacing: 6) {
                HStack { Text("\(cartViewModel.itemCount) item(s)").foregroundColor(.secondary); Spacer(); Text("$\(cartViewModel.subtotal, specifier: "%.2f")") }
                HStack { Text("Shipping").foregroundColor(.secondary); Spacer(); Text("FREE").foregroundColor(.green) }
                if cartViewModel.giftPointsRedeemed > 0 {
                    HStack { Text("Points Discount").foregroundColor(.secondary); Spacer(); Text("-$\(cartViewModel.pointsDiscount, specifier: "%.2f")").foregroundColor(.green) }
                }
                Divider()
                HStack { Text("Total").bold(); Spacer(); Text("$\(cartViewModel.total, specifier: "%.2f")").bold().foregroundColor(Color(hex: "e94560")) }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    func placeOrder() {
        guard let address = selectedAddress else { return }
        let order = cartViewModel.placeOrder(address: address, paymentMethod: selectedPayment)
        placedOrder = order
        showConfirmation = true
    }
}

struct StepsIndicator: View {
    let currentStep: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...3, id: \.self) { step in
                HStack(spacing: 0) {
                    Circle()
                        .fill(step <= currentStep ? Color(hex: "e94560") : Color(.systemGray4))
                        .frame(width: 28, height: 28)
                        .overlay(
                            step < currentStep ?
                            Image(systemName: "checkmark").font(.caption.bold()).foregroundColor(.white) :
                            nil
                        )
                        .overlay(
                            step == currentStep || step > currentStep ?
                            Text("\(step)").font(.caption.bold()).foregroundColor(step <= currentStep ? .white : .secondary) :
                            nil
                        )
                    
                    if step < 3 {
                        Rectangle()
                            .fill(step < currentStep ? Color(hex: "e94560") : Color(.systemGray4))
                            .frame(height: 2)
                    }
                }
            }
        }
        .padding(.horizontal, 40)
    }
}

struct AddressCard: View {
    let address: DeliveryAddress
    let isSelected: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(isSelected ? Color(hex: "e94560") : Color(.systemGray5))
                    .frame(width: 36, height: 36)
                Image(systemName: address.name == "Home" ? "house.fill" : "building.2.fill")
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : .secondary)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(address.name).font(.subheadline.bold())
                    if address.isDefault {
                        Text("Default").font(.system(size: 10)).foregroundColor(.white).padding(.horizontal, 6).padding(.vertical, 2).background(Color.green).cornerRadius(4)
                    }
                }
                Text(address.fullAddress).font(.caption).foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? Color(hex: "e94560") : .secondary)
        }
        .padding()
        .background(isSelected ? Color(hex: "e94560").opacity(0.05) : Color(.systemGray6))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? Color(hex: "e94560") : Color.clear, lineWidth: 1.5))
    }
}

struct PaymentOptionRow: View {
    let method: PaymentMethod
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color(hex: "e94560").opacity(0.1) : Color(.systemGray5))
                    .frame(width: 40, height: 40)
                Image(systemName: method.icon)
                    .foregroundColor(isSelected ? Color(hex: "e94560") : .secondary)
            }
            Text(method.rawValue).font(.subheadline)
            Spacer()
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isSelected ? Color(hex: "e94560") : .secondary)
        }
        .padding()
        .background(isSelected ? Color(hex: "e94560").opacity(0.05) : Color(.systemGray6))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? Color(hex: "e94560") : Color.clear, lineWidth: 1.5))
    }
}

#Preview {
    let cart = CartViewModel()
    cart.addToCart(SampleData.books[0])
    cart.addToCart(SampleData.books[1])
    let auth = AuthViewModel()
    auth.currentUser = SampleData.user
    return NavigationView {
        CheckoutView()
            .environmentObject(cart)
            .environmentObject(auth)
    }
}

#Preview("Address Card - Selected") {
    VStack(spacing: 12) {
        AddressCard(address: SampleData.addresses[0], isSelected: true)
        AddressCard(address: SampleData.addresses[1], isSelected: false)
    }
    .padding()
}

#Preview("Payment Option Row") {
    VStack(spacing: 8) {
        PaymentOptionRow(method: .creditCard, isSelected: true)
        PaymentOptionRow(method: .upi, isSelected: false)
        PaymentOptionRow(method: .giftCard, isSelected: false)
    }
    .padding()
}

#Preview("Steps Indicator") {
    VStack(spacing: 20) {
        StepsIndicator(currentStep: 1)
        StepsIndicator(currentStep: 2)
        StepsIndicator(currentStep: 3)
    }
    .padding()
}
