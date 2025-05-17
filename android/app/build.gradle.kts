import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

// 1. Agora carregamos local.properties **somente neste arquivo**
val localProps = Properties().apply {
    file("${rootDir}/local.properties").takeIf { it.exists() }?.inputStream()?.use { load(it) }
}

android {
    // 2. Extraímos os valores do Flutter via local.properties
    val flutterVersionCode: Int = localProps.getProperty("flutter.versionCode")?.toInt() ?: 1
    val flutterVersionName: String = localProps.getProperty("flutter.versionName") ?: "1.0.0"

    namespace = "com.ussd.infoplus"            // obrigatório AGP 8+
    compileSdk = 33

    ndkVersion = "27.0.12077973"                // NDK exigido pelos plugins

    defaultConfig {
        applicationId = "com.ussd.infoplus"
        minSdk = 23                             // exigido pelo firebase_auth
        targetSdk = 33
        versionCode = flutterVersionCode
        versionName = flutterVersionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.10.1")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.9.0")
    implementation("androidx.multidex:multidex:2.0.1")
}