package dev.mercado.orders

import dev.mercado.cart.CartRepository
import dev.mercado.storage.KeyValueStore
import kotlinx.coroutines.delay
import kotlinx.serialization.Serializable
import kotlinx.serialization.builtins.ListSerializer
import kotlinx.serialization.json.Json

@Serializable
data class OrderItem(
    val productId: String,
    val name: String,
    val qty: Int,
    val price: Double,
)

@Serializable
enum class OrderStatus {
    placed, shipped, delivered;

    val label: String
        get() = when (this) {
            placed -> "Order placed"
            shipped -> "On the way"
            delivered -> "Delivered"
        }
}

@Serializable
data class Order(
    val id: String,
    val items: List<OrderItem>,
    val total: Double,
    val address: String,
    val status: OrderStatus,
    val createdAt: Long,
)

/** Orders persist on-device, newest first. */
class OrdersRepository(
    private val cart: CartRepository,
    private val store: KeyValueStore = KeyValueStore,
) {
    private val json = Json { ignoreUnknownKeys = true }
    private val serializer = ListSerializer(Order.serializer())

    suspend fun history(): List<Order> {
        delay(400)
        return load()
    }

    suspend fun place(address: String, nowMillis: Long): Order {
        val order = Order(
            id = "o$nowMillis",
            items = cart.items().map { OrderItem(it.product.id, it.product.name, it.qty, it.product.price) },
            total = cart.total(),
            address = address,
            status = OrderStatus.placed,
            createdAt = nowMillis,
        )
        store.set(ORDERS_KEY, json.encodeToString(serializer, listOf(order) + load()))
        cart.clear()
        delay(800)
        return order
    }

    private fun load(): List<Order> = store.get(ORDERS_KEY)?.let {
        runCatching { json.decodeFromString(serializer, it) }.getOrNull()
    } ?: emptyList()

    private companion object {
        const val ORDERS_KEY = "mercado.orders"
    }
}
