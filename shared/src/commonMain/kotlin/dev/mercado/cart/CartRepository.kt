package dev.mercado.cart

import dev.mercado.catalog.CatalogRepository
import dev.mercado.catalog.Product

data class CartLine(
    val product: Product,
    val qty: Int,
) {
    val lineTotal: Double get() = product.price * qty
}

/**
 * The cart is deliberately in-memory only: it resets on relaunch, mirroring
 * how the product behaves for signed-out visitors in the real service.
 */
class CartRepository(
    private val catalog: CatalogRepository,
) {
    private val lines = linkedMapOf<String, Int>()   // productId -> qty

    fun add(productId: String, qty: Int) {
        if (catalog.byId(productId) == null) return
        lines[productId] = (lines[productId] ?: 0) + qty
    }

    fun remove(productId: String) {
        lines.remove(productId)
    }

    fun clear() {
        lines.clear()
    }

    fun items(): List<CartLine> = lines.mapNotNull { (id, qty) ->
        catalog.byId(id)?.let { CartLine(it, qty) }
    }

    fun itemCount(): Int = lines.values.sum()

    fun total(): Double = items().sumOf { it.lineTotal }
}
