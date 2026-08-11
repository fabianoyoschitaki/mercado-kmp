package dev.mercado.shared

// In-memory catalog — the same data as the RN app's src/services/data/catalog.ts.
object Catalog {
    val products: List<Product> = listOf(
        Product("p01", "🍌", "Bananas", "Fresh bananas, per kg", 5.9, "produce", "s1"),
        Product("p02", "🍅", "Tomatoes", "Ripe tomatoes, per kg", 8.5, "produce", "s1"),
        Product("p03", "🥬", "Lettuce", "Crisp lettuce head", 3.5, "produce", "s2"),
        Product("p04", "🍞", "Sourdough Bread", "Baked this morning", 14.0, "bakery", "s2"),
        Product("p05", "🥐", "Croissant", "Butter croissant", 6.5, "bakery", "s2"),
        Product("p06", "🥛", "Whole Milk", "1L whole milk", 4.8, "dairy", "s1"),
        Product("p07", "🧀", "Minas Cheese", "Traditional minas cheese, 500g", 22.0, "dairy", "s1"),
        Product("p08", "🥣", "Yogurt", "Natural yogurt, 170g", 3.2, "dairy", "s2"),
        Product("p09", "🍚", "Rice 5kg", "White rice, 5kg bag", 27.9, "pantry", "s1"),
        Product("p10", "🫘", "Black Beans", "Black beans, 1kg", 9.4, "pantry", "s1"),
        Product("p11", "🫒", "Olive Oil", "Extra virgin, 500ml", 32.0, "pantry", "s2"),
        Product("p12", "☕", "Coffee 500g", "Ground coffee, medium roast", 18.9, "pantry", "s1", active = false),
    )

    val categories: List<String> = listOf("produce", "bakery", "dairy", "pantry")

    fun listProducts(): List<Product> = products.filter { it.active }

    fun search(query: String, category: String?): List<Product> {
        val q = query.trim().lowercase()
        return products.filter { p ->
            p.active &&
                (q.isEmpty() || p.name.lowercase().contains(q)) &&
                (category == null || p.category == category)
        }
    }

    fun product(id: String): Product? = products.find { it.id == id }
}
