package dev.mercado

import dev.mercado.catalog.CatalogRepository
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNull
import kotlin.test.assertTrue

class CatalogRepositoryTest {

    private val catalog = CatalogRepository()

    @Test
    fun inactiveProductsAreHiddenFromTheActiveList() {
        assertTrue(catalog.active().none { it.id == "p12" })
    }

    @Test
    fun byIdFindsDelistedProductsToo() {
        // the cart/orders history may still reference a delisted product
        assertEquals("Coffee 500g", catalog.byId("p12")?.name)
    }

    @Test
    fun byIdReturnsNullForUnknownIds() {
        assertNull(catalog.byId("p99"))
    }
}
