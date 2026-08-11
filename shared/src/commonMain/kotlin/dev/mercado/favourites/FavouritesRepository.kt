package dev.mercado.favourites

import dev.mercado.storage.KeyValueStore

/** Favourite product ids, persisted on-device as a comma-separated list. */
class FavouritesRepository(
    private val store: KeyValueStore = KeyValueStore,
) {
    fun ids(): List<String> =
        store.get(FAVS_KEY)?.split(",")?.filter { it.isNotBlank() } ?: emptyList()

    fun contains(productId: String): Boolean = productId in ids()

    /** Returns the new favourite state for the product. */
    fun toggle(productId: String): Boolean {
        val favs = ids().toMutableList()
        val nowFav = if (productId in favs) {
            favs.remove(productId); false
        } else {
            favs.add(productId); true
        }
        store.set(FAVS_KEY, favs.joinToString(","))
        return nowFav
    }

    private companion object {
        const val FAVS_KEY = "mercado.favs"
    }
}
