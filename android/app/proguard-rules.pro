# Add project specific ProGuard rules here.

# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.api.** { *; }
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn com.google.firebase.**

# Firestore
-keep class com.google.firebase.firestore.** { *; }
-keepattributes InnerClasses
-keepattributes Signature
-keepattributes EnclosingMethod

# Cloud Firestore model classes
-keep class com.example.vehicle_impound_app.** { *; }
-keep class * extends com.google.firebase.firestore.Exclude { *; }

# Keep model classes used with Firestore
-keepclassmembers class * {
    @com.google.firebase.firestore.Exclude <fields>;
}

# Keep all model classes that might be serialized with Firestore
-keep class com.example.vehicle_impound_app.model.** { *; }
-keep class com.example.vehicle_impound_app.models.** { *; }

# Keep all custom model classes
-keep class * implements com.google.firebase.firestore.IgnoreExtraProperties { *; }

# Keep all enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep all Parcelable implementations
-keep class * implements android.os.Parcelable {
    public static final ** CREATOR;
}

# Keep all custom exceptions
-keep public class * extends java.lang.Exception

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep all custom views
-keep public class * extends android.view.View {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
    public void set*(...);
    *** get*();
}