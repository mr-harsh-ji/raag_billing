pluginManagement {
    System.setProperty("ANDROID_PREFS_ROOT", "")

    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        properties.getProperty("flutter.sdk")
            ?: error("flutter.sdk not set in local.properties")
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"

    // UPDATE THESE
    id("com.android.application") version "9.0.0" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
