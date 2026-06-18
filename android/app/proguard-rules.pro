# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Supabase (important)
-keep class io.supabase.** { *; }

# Gson / JSON parsing
-keep class com.google.gson.** { *; }
-keepattributes Signature

# Keep model classes (important models)
-keep class com.routina.app.** { *; }

# Remove logs
-assumenosideeffects class android.util.Log {
    *;
}
# Kotlin
-keep class kotlin.** { *; }
-keepclassmembers class **$WhenMappings { *; }

# Coroutines
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory { *; }

-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }