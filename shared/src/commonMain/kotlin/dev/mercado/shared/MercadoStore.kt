package dev.mercado.shared

import kotlinx.serialization.builtins.ListSerializer
import kotlinx.serialization.json.Json

/**
 * The app's business core, shared across platforms. Mirrors the RN app's
 * services: seeded users, session persistence, in-memory cart, persisted
 * orders and favourites. UI layers stay thin and platform-native.
 */
object MercadoStore {
    private const val SESSION_KEY = "mercado.session"
    private const val ORDERS_KEY = "mercado.orders"
    private const val FAVS_KEY = "mercado.favs"

    private val json = Json { ignoreUnknownKeys = true }

    // Demo accounts. Plain text because this app has no backend.
    private data class Account(val user: User, val password: String)

    private val accounts = listOf(
        Account(User("buyer@demo.test", "Bia Buyer"), "grocery123"),
        Account(User("seller@demo.test", "Sergio Seller", isSeller = true, sellerId = "s1"), "banana456"),
    )

    // ---- auth ----

    class LoginException(message: String) : Exception(message)

    @Throws(LoginException::class)
    fun login(email: String, password: String): User {
        val found = accounts.find {
            it.user.email.equals(email.trim(), ignoreCase = true) && it.password == password
        } ?: throw LoginException("Email or password is incorrect. Please try again.")
        KeyValueStore.set(SESSION_KEY, json.encodeToString(User.serializer(), found.user))
        return found.user
    }

    fun sessionUser(): User? = KeyValueStore.get(SESSION_KEY)?.let {
        runCatching { json.decodeFromString(User.serializer(), it) }.getOrNull()
    }

    fun logout() {
        KeyValueStore.remove(SESSION_KEY)
    }

    // ---- cart (in-memory, resets on relaunch — same as the RN context) ----

    private val cart = mutableListOf<CartItem>()

    fun cartItems(): List<CartItem> = cart.toList()

    fun cartCount(): Int = cart.sumOf { it.qty }

    fun cartTotal(): Double = cart.sumOf { it.product.price * it.qty }

    fun addToCart(productId: String, qty: Int) {
        val product = Catalog.product(productId) ?: return
        val idx = cart.indexOfFirst { it.product.id == productId }
        if (idx >= 0) {
            cart[idx] = cart[idx].copy(qty = cart[idx].qty + qty)
        } else {
            cart.add(CartItem(product, qty))
        }
    }

    fun removeFromCart(productId: String) {
        cart.removeAll { it.product.id == productId }
    }

    fun clearCart() {
        cart.clear()
    }

    // ---- orders (persisted, newest first — same as the RN AsyncStorage list) ----

    fun orders(): List<Order> = KeyValueStore.get(ORDERS_KEY)?.let {
        runCatching { json.decodeFromString(ListSerializer(Order.serializer()), it) }.getOrNull()
    } ?: emptyList()

    fun placeOrder(address: String, nowMillis: Long): Order {
        val order = Order(
            id = "o$nowMillis",
            items = cart.map { OrderItem(it.product.id, it.product.name, it.qty, it.product.price) },
            total = cartTotal(),
            address = address,
            status = "placed",
            createdAt = nowMillis,
        )
        val all = listOf(order) + orders()
        KeyValueStore.set(ORDERS_KEY, json.encodeToString(ListSerializer(Order.serializer()), all))
        clearCart()
        return order
    }

    // ---- favourites (persisted ids) ----

    fun favouriteIds(): List<String> = KeyValueStore.get(FAVS_KEY)
        ?.split(",")?.filter { it.isNotBlank() } ?: emptyList()

    fun toggleFavourite(productId: String): Boolean {
        val favs = favouriteIds().toMutableList()
        val isFav = productId in favs
        if (isFav) favs.remove(productId) else favs.add(productId)
        KeyValueStore.set(FAVS_KEY, favs.joinToString(","))
        return !isFav
    }
}
