package dev.mercado.catalog

import kotlinx.coroutines.delay

/**
 * In-memory catalog. There is no backend in this build: the list below is the
 * source of truth and the small delays stand in for network latency, so the
 * UI exercises its loading states like it would in production.
 */
class CatalogRepository {

    private val products = listOf(
        Product("p01", "🍌", "Bananas", "Fresh bananas, per kg", 5.9, Category.produce, "s1"),
        Product("p02", "🍅", "Tomatoes", "Ripe tomatoes, per kg", 8.5, Category.produce, "s1"),
        Product("p03", "🥬", "Lettuce", "Crisp lettuce head", 3.5, Category.produce, "s2"),
        Product("p04", "🍞", "Sourdough Bread", "Baked this morning", 14.0, Category.bakery, "s2"),
        Product("p05", "🥐", "Croissant", "Butter croissant", 6.5, Category.bakery, "s2"),
        Product("p06", "🥛", "Whole Milk", "1L whole milk", 4.8, Category.dairy, "s1"),
        Product("p07", "🧀", "Minas Cheese", "Traditional minas cheese, 500g", 22.0, Category.dairy, "s1"),
        Product("p08", "🥣", "Yogurt", "Natural yogurt, 170g", 3.2, Category.dairy, "s2"),
        Product("p09", "🍚", "Rice 5kg", "White rice, 5kg bag", 27.9, Category.pantry, "s1"),
        Product("p10", "🫘", "Black Beans", "Black beans, 1kg", 9.4, Category.pantry, "s1"),
        Product("p11", "🫒", "Olive Oil", "Extra virgin, 500ml", 32.0, Category.pantry, "s2"),
        Product("p12", "☕", "Coffee 500g", "Ground coffee, medium roast", 18.9, Category.pantry, "s1", active = false),
    )

    val categories: List<Category> = Category.entries

    /** Search is the hot path of the Home screen; keep the latency short. */
    suspend fun search(query: String, category: Category? = null): List<Product> {
        delay(250)
        val q = query.trim().lowercase()
        return products.filter { p ->
            p.active &&
                (q.isEmpty() || p.name.lowercase().contains(q)) &&
                (category == null || p.category == category)
        }
    }

    fun byId(id: String): Product? = products.find { it.id == id }

    fun active(): List<Product> = products.filter { it.active }
}
