package dev.mercado.catalog

import kotlinx.serialization.Serializable

@Serializable
data class Product(
    val id: String,
    val icon: String,
    val name: String,
    val description: String,
    val price: Double,
    val category: Category,
    val sellerId: String,
    val active: Boolean = true,
)

@Serializable
enum class Category {
    produce, bakery, dairy, pantry;
}

val Product.sellerName: String
    get() = when (sellerId) {
        "s1" -> "Sunny Farms"
        "s2" -> "Village Market"
        else -> "Mercado partner"
    }
