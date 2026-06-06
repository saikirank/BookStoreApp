#!/bin/bash
# ============================================================
# BookHaven iOS App — GitHub Setup Script
# Run this from the BookstoreApp/ root directory
# ============================================================

set -e

echo "🚀 BookHaven iOS App — GitHub Setup"
echo "======================================"

# 1. Initialize git repo
git init
git add .
git commit -m "feat: initial BookHaven iOS app with all 10 screens

- Login screen with animated dark UI
- Home screen with hero banner, categories, featured books
- Catalogue with search, filter by category/brand, sort
- Product detail with ratings, delivery date, related books
- Cart with quantity management and AI recommendations
- Checkout with address selection, gift points redemption
- Payment method selection (Credit/Debit/UPI/NetBanking/Gift)
- Order confirmation with 48hr cancel option
- Order history with Buy Again and status badges
- Profile with stats, addresses, gift points

Architecture: MVVM with SwiftUI + Combine
Min iOS: 16.0"

# 2. Create feature branch
git checkout -b feature/bookhaven-ios-app

# 3. Add remote (replace with your GitHub username)
echo ""
echo "📌 Next steps — run these commands:"
echo ""
echo "  # Create a new repo on GitHub named 'BookHaven-iOS', then:"
echo "  git remote add origin https://github.com/YOUR_USERNAME/BookHaven-iOS.git"
echo "  git push -u origin feature/bookhaven-ios-app"
echo ""
echo "  # Then create a Pull Request on GitHub for Manager Review"
echo ""
echo "✅ Local git setup complete!"
