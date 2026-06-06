import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        // Simulate network call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.isLoading = false
            if email.lowercased() == "alex@example.com" && password == "password" {
                self.currentUser = SampleData.user
                self.isLoggedIn = true
            } else if !email.isEmpty && !password.isEmpty {
                // Allow any credentials for demo
                self.currentUser = User(id: UUID().uuidString, name: email.components(separatedBy: "@").first?.capitalized ?? "User", email: email, giftPoints: 500, addresses: SampleData.addresses)
                self.isLoggedIn = true
            } else {
                self.errorMessage = "Please enter valid credentials"
            }
        }
    }
    
    func logout() {
        isLoggedIn = false
        currentUser = nil
    }
}
