plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle Plugin WAJIB terakhir
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.mochi"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.mochi"

        // ✅ FIX: minSdk HARUS di sini
        minSdk = flutter.minSdkVersion

        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // sementara pakai debug key (AMAN untuk sekarang)
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // ✅ SUDAH BENAR (jangan dihapus)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")

    // 🔥 WAJIB UNTUK GOOGLE MAPS
    implementation("com.google.android.gms:play-services-maps:18.2.0")
}

flutter {
    source = "../.."
}
