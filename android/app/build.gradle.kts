import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.ussd.infoplus"           // Namespace obrigatório AGP 8+
    compileSdk = 33                           // SDK de compilação

    // 1) Força a NDK 27 compatível com FlutterFire e outros plugins
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.ussd.infoplus"
        minSdk = 23                           // API mínima exigida pelos plugins Firebase
        targetSdk = 33
        versionCode = project
            .properties["flutter.versionCode"]
            .toString()
            .toInt()
        versionName = project
            .properties["flutter.versionName"]
            .toString()
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
        debug {
            // configurações específicas de debug, se precisar
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
    // outras dependências do seu app aqui...
}

// Se você precisar adicionar fontes ou assets, ajuste aqui:
android.sourceSets["main"].apply {
    assets.srcDir("src/main/assets")
    // resources, java, etc.
}