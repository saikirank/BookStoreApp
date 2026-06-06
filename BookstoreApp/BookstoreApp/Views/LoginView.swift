import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @FocusState private var focusedField: Field?
    
    enum Field { case email, password }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "1a1a2e"), Color(hex: "16213e"), Color(hex: "0f3460")],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Logo Section
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "e94560").opacity(0.2))
                                .frame(width: 100, height: 100)
                            Image(systemName: "books.vertical.fill")
                                .font(.system(size: 48))
                                .foregroundColor(Color(hex: "e94560"))
                        }
                        Text("BookHaven")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("Your world of books")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 48)
                    
                    // Card
                    VStack(spacing: 20) {
                        Text("Welcome Back")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Email
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email").font(.caption).foregroundColor(.white.opacity(0.6))
                            HStack {
                                Image(systemName: "envelope").foregroundColor(Color(hex: "e94560"))
                                TextField("", text: $email, prompt: Text("you@example.com").foregroundColor(.white.opacity(0.3)))
                                    .foregroundColor(.white)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .focused($focusedField, equals: .email)
                            }
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(focusedField == .email ? Color(hex: "e94560") : Color.white.opacity(0.15), lineWidth: 1))
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password").font(.caption).foregroundColor(.white.opacity(0.6))
                            HStack {
                                Image(systemName: "lock").foregroundColor(Color(hex: "e94560"))
                                Group {
                                    if showPassword {
                                        TextField("", text: $password, prompt: Text("••••••••").foregroundColor(.white.opacity(0.3)))
                                    } else {
                                        SecureField("", text: $password, prompt: Text("••••••••").foregroundColor(.white.opacity(0.3)))
                                    }
                                }
                                .foregroundColor(.white)
                                .focused($focusedField, equals: .password)
                                Button(action: { showPassword.toggle() }) {
                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                        .foregroundColor(.white.opacity(0.5))
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(focusedField == .password ? Color(hex: "e94560") : Color.white.opacity(0.15), lineWidth: 1))
                        }
                        
                        // Error
                        if let error = authViewModel.errorMessage {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
                                Text(error).font(.caption).foregroundColor(.orange)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // Login Button
                        Button(action: { authViewModel.login(email: email, password: password) }) {
                            HStack {
                                if authViewModel.isLoading {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Sign In")
                                        .fontWeight(.semibold)
                                    Image(systemName: "arrow.right")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "e94560"))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                        }
                        .disabled(authViewModel.isLoading)
                        
                        // Demo hint
                        Text("Demo: any email & password")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.4))
                    }
                    .padding(24)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(24)
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                }
            }
        }
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
