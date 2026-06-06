import Foundation

// MARK: - Book Model
struct Book: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let author: String
    let price: Double
    let originalPrice: Double?
    let coverImage: String   // system image name or URL
    let category: BookCategory
    let brand: String
    let rating: Double
    let reviewCount: Int
    let description: String
    let deliveryDate: String
    let inStock: Bool
    var isFavorite: Bool = false
    
    static func == (lhs: Book, rhs: Book) -> Bool { lhs.id == rhs.id }
}

// MARK: - Category
enum BookCategory: String, CaseIterable, Codable, Identifiable {
    case fiction = "Fiction"
    case nonFiction = "Non-Fiction"
    case science = "Science"
    case history = "History"
    case selfHelp = "Self Help"
    case technology = "Technology"
    case romance = "Romance"
    case mystery = "Mystery"
    
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .fiction: return "book.fill"
        case .nonFiction: return "newspaper.fill"
        case .science: return "atom"
        case .history: return "clock.fill"
        case .selfHelp: return "heart.fill"
        case .technology: return "laptopcomputer"
        case .romance: return "heart.circle.fill"
        case .mystery: return "magnifyingglass.circle.fill"
        }
    }
    var color: String {
        switch self {
        case .fiction: return "categoryBlue"
        case .nonFiction: return "categoryGreen"
        case .science: return "categoryPurple"
        case .history: return "categoryOrange"
        case .selfHelp: return "categoryPink"
        case .technology: return "categoryTeal"
        case .romance: return "categoryRed"
        case .mystery: return "categoryIndigo"
        }
    }
}

// MARK: - Cart Item
struct CartItem: Identifiable {
    let id = UUID()
    var book: Book
    var quantity: Int
    
    var total: Double { book.price * Double(quantity) }
}

// MARK: - Order
struct Order: Identifiable {
    let id: String
    let date: Date
    let books: [CartItem]
    let total: Double
    let status: OrderStatus
    let deliveryAddress: DeliveryAddress
    let paymentMethod: PaymentMethod
    var canCancel: Bool {
        let hoursSinceOrder = Date().timeIntervalSince(date) / 3600
        return hoursSinceOrder < 48
    }
}

enum OrderStatus: String {
    case processing = "Processing"
    case shipped = "Shipped"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
    
    var color: String {
        switch self {
        case .processing: return "orange"
        case .shipped: return "blue"
        case .delivered: return "green"
        case .cancelled: return "red"
        }
    }
}

// MARK: - Delivery Address
struct DeliveryAddress: Identifiable, Codable {
    let id: String
    var name: String
    var street: String
    var city: String
    var state: String
    var zipCode: String
    var isDefault: Bool
    
    var fullAddress: String { "\(street), \(city), \(state) \(zipCode)" }
}

// MARK: - Payment Method
enum PaymentMethod: String, CaseIterable {
    case creditCard = "Credit Card"
    case debitCard = "Debit Card"
    case upi = "UPI"
    case netBanking = "Net Banking"
    case giftCard = "Gift Card / Points"
    
    var icon: String {
        switch self {
        case .creditCard, .debitCard: return "creditcard.fill"
        case .upi: return "qrcode"
        case .netBanking: return "building.columns.fill"
        case .giftCard: return "gift.fill"
        }
    }
}

// MARK: - User
struct User: Codable {
    var id: String
    var name: String
    var email: String
    var giftPoints: Int
    var addresses: [DeliveryAddress]
}

// MARK: - Sample Data
struct SampleData {
    static let books: [Book] = [
        Book(id: "1", title: "The Great Gatsby", author: "F. Scott Fitzgerald", price: 12.99, originalPrice: 18.99, coverImage: "book.closed.fill", category: .fiction, brand: "Scribner", rating: 4.5, reviewCount: 2340, description: "A masterpiece of American literature set in the Jazz Age.", deliveryDate: "June 9 - 11", inStock: true),
        Book(id: "2", title: "Sapiens", author: "Yuval Noah Harari", price: 16.99, originalPrice: 22.99, coverImage: "globe.americas.fill", category: .nonFiction, brand: "Harper", rating: 4.8, reviewCount: 5120, description: "A brief history of humankind exploring how Homo sapiens came to rule the world.", deliveryDate: "June 10 - 12", inStock: true),
        Book(id: "3", title: "A Brief History of Time", author: "Stephen Hawking", price: 14.99, originalPrice: nil, coverImage: "sparkles", category: .science, brand: "Bantam", rating: 4.7, reviewCount: 3890, description: "Stephen Hawking's landmark volume in science writing.", deliveryDate: "June 9 - 11", inStock: true),
        Book(id: "4", title: "Atomic Habits", author: "James Clear", price: 18.99, originalPrice: 24.99, coverImage: "bolt.fill", category: .selfHelp, brand: "Avery", rating: 4.9, reviewCount: 8750, description: "Tiny changes, remarkable results.", deliveryDate: "June 8 - 10", inStock: true),
        Book(id: "5", title: "Clean Code", author: "Robert C. Martin", price: 22.99, originalPrice: 29.99, coverImage: "chevron.left.forwardslash.chevron.right", category: .technology, brand: "Prentice Hall", rating: 4.6, reviewCount: 4200, description: "A handbook of agile software craftsmanship.", deliveryDate: "June 10 - 13", inStock: true),
        Book(id: "6", title: "The Alchemist", author: "Paulo Coelho", price: 11.99, originalPrice: 15.99, coverImage: "star.fill", category: .fiction, brand: "HarperOne", rating: 4.7, reviewCount: 9100, description: "A magical story about following your dreams.", deliveryDate: "June 9 - 11", inStock: true),
        Book(id: "7", title: "Educated", author: "Tara Westover", price: 15.99, originalPrice: nil, coverImage: "graduationcap.fill", category: .nonFiction, brand: "Random House", rating: 4.8, reviewCount: 6300, description: "A memoir about a young woman who leaves her survivalist family.", deliveryDate: "June 11 - 13", inStock: false),
        Book(id: "8", title: "The Da Vinci Code", author: "Dan Brown", price: 13.99, originalPrice: 19.99, coverImage: "lock.fill", category: .mystery, brand: "Doubleday", rating: 4.4, reviewCount: 7200, description: "A thrilling mystery involving secret societies.", deliveryDate: "June 9 - 12", inStock: true),
        Book(id: "9", title: "Pride and Prejudice", author: "Jane Austen", price: 9.99, originalPrice: nil, coverImage: "heart.text.square.fill", category: .romance, brand: "Penguin", rating: 4.9, reviewCount: 11200, description: "A timeless romance set in Georgian England.", deliveryDate: "June 8 - 10", inStock: true),
        Book(id: "10", title: "Guns, Germs, and Steel", author: "Jared Diamond", price: 17.99, originalPrice: 23.99, coverImage: "shield.fill", category: .history, brand: "Norton", rating: 4.5, reviewCount: 3100, description: "The fates of human societies explored.", deliveryDate: "June 12 - 14", inStock: true),
        Book(id: "11", title: "Deep Work", author: "Cal Newport", price: 15.99, originalPrice: 20.99, coverImage: "brain.head.profile", category: .selfHelp, brand: "Grand Central", rating: 4.6, reviewCount: 4800, description: "Rules for focused success in a distracted world.", deliveryDate: "June 9 - 11", inStock: true),
        Book(id: "12", title: "The Pragmatic Programmer", author: "Andrew Hunt", price: 24.99, originalPrice: 32.99, coverImage: "hammer.fill", category: .technology, brand: "Addison-Wesley", rating: 4.7, reviewCount: 5600, description: "Your journey to mastery in software development.", deliveryDate: "June 10 - 12", inStock: true),
    ]
    
    static let addresses: [DeliveryAddress] = [
        DeliveryAddress(id: "a1", name: "Home", street: "123 MG Road", city: "Hyderabad", state: "Telangana", zipCode: "500001", isDefault: true),
        DeliveryAddress(id: "a2", name: "Office", street: "456 Jubilee Hills", city: "Hyderabad", state: "Telangana", zipCode: "500033", isDefault: false),
    ]
    
    static let user = User(id: "u1", name: "Alex Johnson", email: "alex@example.com", giftPoints: 1250, addresses: addresses)
}
