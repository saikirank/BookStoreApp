# BookHaven iOS App 📚

A full-featured E-Bookstore iOS application built with **SwiftUI** as part of the AI Specialist Capstone Project.

---

## 📱 Screens & Features

| Screen | Features |
|---|---|
| **Login** | Email/password auth, animated UI, demo credentials |
| **Home** | Hero banner, category quick-access, featured & bestseller carousels |
| **Catalogue** | Search, category/brand filter, sort, discount badges |
| **Product Detail** | Cover art, ratings, delivery estimate, quantity selector, related books |
| **Cart** | Item management, quantity update, AI-powered recommendations |
| **Checkout — Address** | Saved addresses, add new, gift points redemption slider |
| **Checkout — Payment** | Credit/Debit card, UPI, Net Banking, Gift Card selection |
| **Order Confirmation** | Order ID, item summary, cancel within 48 hrs |
| **Order History** | Buy Again feature, order status badge, expand for details |
| **Profile** | Stats, saved addresses, gift points balance, sign out |

---

## 🏗 Architecture

```
BookstoreApp/
├── BookstoreAppApp.swift      # @main entry point
├── Models/
│   └── Models.swift           # Book, CartItem, Order, User, DeliveryAddress
├── ViewModels/
│   ├── AuthViewModel.swift    # Login/logout state
│   ├── CartViewModel.swift    # Cart, orders, gift points
│   └── CatalogueViewModel.swift  # Filtering, sorting, recommendations
├── Views/
│   ├── ContentView.swift      # Auth router
│   ├── MainTabView.swift      # Tab navigation
│   ├── LoginView.swift
│   ├── HomeView.swift         # + BookCardView, Color extensions
│   ├── CatalogueView.swift    # + FilterChip, CatalogueBookCard
│   ├── ProductDetailView.swift
│   ├── CartView.swift         # + CartItemRow
│   ├── CheckoutView.swift     # + StepsIndicator, AddressCard, PaymentOptionRow
│   ├── OrderConfirmationView.swift
│   ├── OrderHistoryView.swift # + OrderCard, StatusBadge
│   └── ProfileView.swift
└── Info.plist
```

**Design Pattern:** MVVM (Model-View-ViewModel)  
**UI Framework:** SwiftUI  
**Min iOS:** 16.0  
**Language:** Swift 5.9+

---

## 🚀 How to Run

1. **Clone the repo:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/BookHaven-iOS.git
   cd BookHaven-iOS
   ```

2. **Open in Xcode:**
   ```bash
   open BookstoreApp.xcodeproj
   ```

3. **Select target:** iPhone 15 Pro (or any iOS 16+ simulator)

4. **Run:** Press `Cmd + R`

5. **Login with:** Any email + any password (demo mode)

---

## 🎨 Design System

- **Primary Color:** `#e94560` (BookHaven Red)
- **Dark Background:** `#0f3460` / `#1a1a2e`
- **Font:** SF Pro (system default)
- **Corner Radius:** 12–16pt cards, 20pt buttons
- **Shadows:** Soft, 6pt radius

---

## 🧠 Developed with Agentic AI

This app was developed using **Agentic Tool** as an agentic coding assistant:

- Requirements extracted from the capstone PPTX via agentic file parsing
- Complete MVVM architecture scaffolded from a single prompt
- All 10+ screens generated with proper SwiftUI patterns
- ViewModels with Combine `@Published` state management
- Sample data model aligned to the business use case

---

## 📋 Customer Journey Coverage

✅ Login & Authentication  
✅ Home / E-store Landing  
✅ Category Selection  
✅ Catalogue Browsing with Brand Filter  
✅ Product Detail with Delivery Date  
✅ Related Products  
✅ Add to Cart / Basket  
✅ Cart with AI Recommendations  
✅ Address Selection for Delivery  
✅ Gift Points Redemption  
✅ Payment Method Selection  
✅ Payment Confirmation  
✅ Order History with Buy-Again  
✅ Cancel Order Within 48 Hours  
