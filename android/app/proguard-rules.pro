# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# Keep Flutter engine classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Keep Dart native functions
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }

# Keep Firebase classes if you're using Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Kotlin serialization classes
-keepattributes *Annotation*, InnerClasses
-dontnote kotlinx.serialization.AnnotationsKt
-keepclassmembers class kotlinx.serialization.json.** {
    *** Companion;
}
-keepclasseswithmembers class kotlinx.serialization.json.** {
    kotlinx.serialization.KSerializer serializer(...);
}

# Keep platform channels
-keep class * extends io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }
-keep class * extends io.flutter.plugin.common.EventChannel$StreamHandler { *; }
# Keep OkHttp (commonly used in Flutter plugins)
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-keepattributes Signature
-keepattributes Exceptions

# Remove debug logging
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
}

# Optimization
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification
-dontpreverify
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose