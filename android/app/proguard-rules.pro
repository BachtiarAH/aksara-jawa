# ProGuard rules for TensorFlow Lite (tflite)

# Keep all classes and methods in the TensorFlow Lite library
-keep class org.tensorflow.** { *; }
-keep class com.google.flatbuffers.** { *; }
-dontwarn org.tensorflow.**

# Keep native methods
-keepclassmembers class * {
    native <methods>;
    @androidx.annotation.Keep *;
}

# Keep classes with @Keep annotation
-keep @androidx.annotation.Keep class * { *; }
-keep @android.support.annotation.Keep class * { *; }