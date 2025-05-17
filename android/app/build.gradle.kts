import java.util.Properties
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

// 1. Carrega o local.properties
val localProperties = Properties().apply {
    val localPropsFile = rootProject.file("local.properties")
    if (localPropsFile.exists()) {
        localPropsFile.inputStream().use { load(it) }
    }
}

android {
    // 2. Usa as propriedades do local.properties
    val flutterSdk: String = localProperties.getProperty("flutter.sdk")
    val flutterVersionCode: Int = localProperties.getProperty("flutter.versionCode").toInt()
    val flutterVersionName: String = localProperties.getProperty("flutter.versionName")

    namespace = "com.ussd.infoplus"              // namespace obrigatório AGP 8+
    compileSdk = 33

    ndkVersion = "27.0.12077973"                  // NDK exigido pelos plugins

    defaultConfig {
        applicationId = "com.ussd.infoplus"
        minSdk = 23                               // mínimo exigido pelo Firebase Auth
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