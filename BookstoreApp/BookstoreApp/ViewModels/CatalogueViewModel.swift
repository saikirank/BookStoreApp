import Foundation
import Combine

class CatalogueViewModel: ObservableObject {
    @Published var allBooks: [Book] = SampleData.books
    @Published var selectedCategory: BookCategory? = nil
    @Published var selectedBrand: String? = nil
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .featured
    
    enum SortOption: String, CaseIterable {
        case featured = "Featured"
        case priceLow = "Price: Low to High"
        case priceHigh = "Price: High to Low"
        case rating = "Top Rated"
    }
    
    var brands: [String] { Array(Set(allBooks.map { $0.brand })).sorted() }
    
    var filteredBooks: [Book] {
        var result = allBooks
        if let cat = selectedCategory { result = result.filter { $0.category == cat } }
        if let brand = selectedBrand { result = result.filter { $0.brand == brand } }
        if !searchText.isEmpty { result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.author.localizedCaseInsensitiveContains(searchText) } }
        switch sortOption {
        case .featured: break
        case .priceLow: result.sort { $0.price < $1.price }
        case .priceHigh: result.sort { $0.price > $1.price }
        case .rating: result.sort { $0.rating > $1.rating }
        }
        return result
    }
    
    func relatedBooks(for book: Book) -> [Book] {
        allBooks.filter { $0.category == book.category && $0.id != book.id }.prefix(4).map { $0 }
    }
    
    func recommendedBooks(basedOnOrders orders: [Order]) -> [Book] {
        guard !orders.isEmpty else { return Array(allBooks.prefix(4)) }
        let orderedCategories = orders.flatMap { $0.books.map { $0.book.category } }
        let topCategory = orderedCategories.reduce(into: [:]) { counts, cat in counts[cat, default: 0] += 1 }.max(by: { $0.value < $1.value })?.key
        if let cat = topCategory {
            return allBooks.filter { $0.category == cat }.prefix(4).map { $0 }
        }
        return Array(allBooks.prefix(4))
    }
}
