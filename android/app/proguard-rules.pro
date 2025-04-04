# Keep ProGuard annotations
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }
-keep @proguard.annotation.Keep class *
-keep @proguard.annotation.KeepClassMembers class *
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
