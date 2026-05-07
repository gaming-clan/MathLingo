# -----------------------------------------------------------------------
# MathLingo ProGuard rules
# -----------------------------------------------------------------------

# Injoro klasat opsionale të ML Kit për gjuhë jolatine (chinese, japanese, etj.)
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**

# Ruaj të gjitha klasat ML Kit që përdoren
-keep class com.google.mlkit.** { *; }
-keep interface com.google.mlkit.** { *; }

# Flutter Play Core / Deferred Components — klasa opsionale që Flutter embedding
# i referenzon por nuk janë të pranishme kur nuk përdorim Play Store split installs.
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# Ruaj klasat Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Ruaj entry-point-et e aplikacionit
-keep class com.mathlingo.app.** { *; }
