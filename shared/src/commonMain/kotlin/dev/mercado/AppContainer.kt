package dev.mercado

import dev.mercado.auth.AuthRepository
import dev.mercado.cart.CartRepository
import dev.mercado.catalog.CatalogRepository
import dev.mercado.favourites.FavouritesRepository
import dev.mercado.orders.OrdersRepository

/**
 * Manual dependency wiring — the app is small enough that a DI framework
 * would be ceremony. Platform clients grab this one object and reach the
 * repositories through it.
 */
object AppContainer {
    val catalog: CatalogRepository = CatalogRepository()
    val auth: AuthRepository = AuthRepository()
    val cart: CartRepository = CartRepository(catalog)
    val orders: OrdersRepository = OrdersRepository(cart)
    val favourites: FavouritesRepository = FavouritesRepository()
}
