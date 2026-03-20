# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Dio / OkHttp / Retrofit
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-keep class okio.** { *; }

# Branch SDK
-keep class io.branch.** { *; }
-keep class com.google.android.gms.ads.identifier.** { *; }
-dontwarn io.branch.**

# Permission Handler
-keep class com.baseflow.permissionhandler.** { *; }
-dontwarn com.baseflow.permissionhandler.**

# WebView (flutter_inappwebview / webview_flutter)
-keep class com.pichillilorenzo.flutter_inappwebview.** { *; }
-keep class io.flutter.plugins.webviewflutter.** { *; }
-dontwarn com.pichillilorenzo.flutter_inappwebview.**
-dontwarn io.flutter.plugins.webviewflutter.**

# Datadog
-keep class com.datadog.** { *; }
-keep class com.datadoghq.** { *; }
-dontwarn com.datadog.**
-dontwarn com.datadoghq.**

# Drift / SQLite
-keep class androidx.sqlite.** { *; }
-keep class androidx.room.** { *; }
-dontwarn androidx.sqlite.**
-keep class app.cash.sqldelight.** { *; }
-dontwarn app.cash.sqldelight.**
