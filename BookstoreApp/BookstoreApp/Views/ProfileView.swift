import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var showLogoutAlert = false
    
    var user: User { authViewModel.currentUser ?? SampleData.user }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Avatar
                    VStack(spacing: 10) {
                        ZStack {
                            LinearGradient(colors: [Color(hex: "e94560"), Color(hex: "0f3460")], startPoint: .topLeading, endPoint: .bottomTrailing)
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                            Text(user.name.prefix(1).uppercased())
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        }
                        Text(user.name).font(.title2.bold())
                        Text(user.email).font(.subheadline).foregroundColor(.secondary)
                        
                        // Gift Points
                        HStack(spacing: 6) {
                            Image(systemName: "gift.fill").foregroundColor(Color(hex: "e94560"))
                            Text("\(user.giftPoints) Gift Points").font(.subheadline.bold())
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color(hex: "e94560").opacity(0.08))
                        .cornerRadius(20)
                    }
                    .padding(.top, 20)
                    
                    // Stats
                    HStack(spacing: 0) {
                        statCell(value: "\(cartViewModel.orders.count)", label: "Orders")
                        Divider().frame(height: 40)
                        statCell(value: "\(cartViewModel.orders.filter { $0.status == .delivered }.count)", label: "Delivered")
                        Divider().frame(height: 40)
                        statCell(value: "\(user.giftPoints)", label: "Points")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Menu
                    VStack(spacing: 0) {
                        profileMenuRow(icon: "person.fill", title: "Personal Info", subtitle: "Update your details")
                        Divider().padding(.leading, 52)
                        profileMenuRow(icon: "location.fill", title: "Saved Addresses", subtitle: "\(user.addresses.count) addresses saved")
                        Divider().padding(.leading, 52)
                        profileMenuRow(icon: "gift.fill", title: "Gift Points", subtitle: "\(user.giftPoints) points = $\(user.giftPoints / 100) discount")
                        Divider().padding(.leading, 52)
                        profileMenuRow(icon: "bell.fill", title: "Notifications", subtitle: "Manage alerts")
                        Divider().padding(.leading, 52)
                        profileMenuRow(icon: "questionmark.circle.fill", title: "Help & Support", subtitle: "FAQ, Contact us")
                        Divider().padding(.leading, 52)
                        profileMenuRow(icon: "shield.fill", title: "Privacy Policy", subtitle: "Read our policy")
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.06), radius: 6)
                    .padding(.horizontal)
                    
                    // Logout
                    Button(action: { showLogoutAlert = true }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.08))
                        .foregroundColor(.red)
                        .cornerRadius(14)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("My Profile")
            .alert("Sign Out?", isPresented: $showLogoutAlert) {
                Button("Sign Out", role: .destructive) { authViewModel.logout() }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    func statCell(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.title2.bold()).foregroundColor(Color(hex: "e94560"))
            Text(label).font(.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    func profileMenuRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8).fill(Color(hex: "e94560").opacity(0.1)).frame(width: 36, height: 36)
                Image(systemName: icon).foregroundColor(Color(hex: "e94560")).font(.body)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline.bold())
                Text(subtitle).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    let auth = AuthViewModel()
    auth.currentUser = SampleData.user
    auth.isLoggedIn = true
    let cart = CartViewModel()
    cart.addToCart(SampleData.books[0])
    let _ = cart.placeOrder(address: SampleData.addresses[0], paymentMethod: .creditCard)
    return ProfileView()
        .environmentObject(auth)
        .environmentObject(cart)
}
