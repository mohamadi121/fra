# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.plugin.editing.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Google Maps
-keep class com.google.android.gms.maps.** { *; }
-keep interface com.google.android.gms.maps.** { *; }

# Isar
-keep class com.github.fkorotkov.k2j.** { *; }
-keep class isar.** { *; }
-keep enum isar.** { *; }

# Location
-keep class com.lyokone.location.** { *; }

# Keep JSON models
-keepclassmembers class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# OkHttp3
-keepattributes Signature
-keepattributes *Annotation*
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontnote okhttp3.**

# Retrofit
-keepattributes Signature
-keepattributes Exceptions

# Keep model classes
-keep class com.asood.vendor.models.** { *; }