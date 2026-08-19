package dev.mercado.auth

import dev.mercado.storage.KeyValueStore
import kotlinx.coroutines.delay
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json

@Serializable
data class User(
    val email: String,
    val name: String,
    val isSeller: Boolean = false,
    val sellerId: String? = null,
)

class LoginException(message: String) : Exception(message)

/**
 * Seeded demo accounts — this build ships without a backend. The session is
 * persisted so the app resumes logged in across launches.
 */
class AuthRepository(
    private val store: KeyValueStore = KeyValueStore,
) {
    private val json = Json { ignoreUnknownKeys = true }

    private val accounts = mapOf(
        "buyer@demo.test" to Pair("grocery123", User("buyer@demo.test", "Bia Buyer")),
        "seller@demo.test" to Pair("banana456", User("seller@demo.test", "Sergio Seller", isSeller = true, sellerId = "s1")),
    )

    @Throws(LoginException::class, kotlin.coroutines.cancellation.CancellationException::class)
    suspend fun login(email: String, password: String): User {
        // the auth roundtrip is the slowest call in the app, like in production
        delay(700)
        val entry = accounts[email.trim().lowercase()]
        if (entry == null || entry.first != password) {
            throw LoginException("Incorrect email or password — check your credentials and try again.")
        }
        store.set(SESSION_KEY, json.encodeToString(User.serializer(), entry.second))
        return entry.second
    }

    fun currentSession(): User? = store.get(SESSION_KEY)?.let {
        runCatching { json.decodeFromString(User.serializer(), it) }.getOrNull()
    }

    fun logout() {
        store.remove(SESSION_KEY)
    }

    private companion object {
        const val SESSION_KEY = "mercado.session"
    }
}

// touched by an autopilot sync smoke test (2026-08-19) — no behavior change
