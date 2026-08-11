package dev.mercado.shared

// Platform key-value persistence (the RN app's AsyncStorage counterpart).
expect object KeyValueStore {
    fun get(key: String): String?
    fun set(key: String, value: String)
    fun remove(key: String)
}
