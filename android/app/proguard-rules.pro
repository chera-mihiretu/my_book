# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Suppress warnings for Play Core (fixes the R8 build error)
-dontwarn com.google.android.play.core.**

# Recommended: Keep Firebase and Supabase classes safe from shrinking
-keep class com.google.firebase.** { *; }
-keep class io.github.jan.supabase.** { *; }