plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.geniaes.student"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // ✅ Kotlin DSL uses assignment
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.geniaes.student"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
    getByName("release") {
        // temporarily sign with debug keys so release builds work
        signingConfig = signingConfigs.getByName("debug")
        isMinifyEnabled = true
        isShrinkResources = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
    getByName("debug") {
        signingConfig = signingConfigs.getByName("debug")
    }
    }

}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.material:material:1.11.0")
    implementation("org.slf4j:slf4j-simple:1.7.36")

    // ✅ Kotlin DSL uses function call syntax
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}
