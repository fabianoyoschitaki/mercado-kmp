package dev.mercado

import dev.mercado.cart.CartRepository
import dev.mercado.catalog.CatalogRepository
import kotlin.test.Test
import kotlin.test.assertEquals

class CartRepositoryTest {

    private fun freshCart() = CartRepository(CatalogRepository())

    @Test
    fun addingSameProductTwiceMergesTheLine() {
        val cart = freshCart()
        cart.add("p01", 1)
        cart.add("p01", 2)
        assertEquals(1, cart.items().size)
        assertEquals(3, cart.itemCount())
    }

    @Test
    fun totalSumsLineTotals() {
        val cart = freshCart()
        cart.add("p01", 2)   // Bananas 5.90
        cart.add("p03", 1)   // Lettuce 3.50
        assertEquals(15.3, cart.total(), absoluteTolerance = 0.001)
    }

    @Test
    fun unknownProductsAreIgnored() {
        val cart = freshCart()
        cart.add("nope", 1)
        assertEquals(0, cart.itemCount())
    }

    @Test
    fun removeDropsTheWholeLine() {
        val cart = freshCart()
        cart.add("p01", 3)
        cart.remove("p01")
        assertEquals(0, cart.itemCount())
    }
}
