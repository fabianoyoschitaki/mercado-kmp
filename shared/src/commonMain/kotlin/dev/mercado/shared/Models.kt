package dev.mercado.shared

import kotlinx.serialization.Serializable

@Serializable
data class Product(
    val id: String,
    val icon: String,
    val name: String,
    val description: String,
    val price: Double,
    val category: String,
    val sellerId: String,
    val active: Boolean = true,
)

@Serializable
data class User(
    val email: String,
    val name: String,
    val isSeller: Boolean = false,
    val sellerId: String? = null,
)

@Serializable
data class OrderItem(
    val productId: String,
    val name: String,
    val qty: Int,
    val price: Double,
)

@Serializable
data class Order(
    val id: String,
    val items: List<OrderItem>,
    val total: Double,
    val address: String,
    val status: String,          // placed | shipped | delivered
    val createdAt: Long,
)

data class CartItem(
    val product: Product,
    val qty: Int,
)
