# Mercado (Kotlin Multiplatform)

Grocery marketplace app — buyer side. Business core shared in Kotlin
(`shared/`: catalog, auth with seeded accounts, cart, orders, favourites),
native SwiftUI iOS client (`iosApp/`).

## Build (iOS simulator)

```bash
./scripts/build-ios-simulator.sh
xcrun simctl install booted iosApp/build/Debug-iphonesimulator/Mercado.app
```

Requires Xcode + JDK 17 (Kotlin/Native toolchain downloads on first build).

## Demo accounts

Login is required to reach any screen. Seeded users (no backend):
buyer@demo.test / grocery123 · seller@demo.test / banana456
