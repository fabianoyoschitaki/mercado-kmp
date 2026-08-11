package dev.mercado.storage

/** Platform key-value persistence (session, orders, favourites). */
expect object KeyValueStore {
    fun get(key: String): String?
    fun set(key: String, value: String)
    fun remove(key: String)
}
