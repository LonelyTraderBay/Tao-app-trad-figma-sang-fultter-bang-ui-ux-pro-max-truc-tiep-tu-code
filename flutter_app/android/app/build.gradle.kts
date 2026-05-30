import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val releaseKeystorePropertiesFile = rootProject.file("key.properties")
val releaseKeystoreProperties = Properties()
if (releaseKeystorePropertiesFile.exists()) {
    releaseKeystorePropertiesFile.inputStream().use {
        releaseKeystoreProperties.load(it)
    }
}

fun releaseSigningValue(propertyName: String, environmentName: String): String? {
    return releaseKeystoreProperties.getProperty(propertyName)
        ?: System.getenv(environmentName)
}

val releaseStoreFile = releaseSigningValue("storeFile", "VITTRADE_KEYSTORE_PATH")
val releaseStorePassword = releaseSigningValue(
    "storePassword",
    "VITTRADE_KEYSTORE_PASSWORD",
)
val releaseKeyAlias = releaseSigningValue("keyAlias", "VITTRADE_KEY_ALIAS")
val releaseKeyPassword = releaseSigningValue("keyPassword", "VITTRADE_KEY_PASSWORD")
val hasReleaseSigning = listOf(
    releaseStoreFile,
    releaseStorePassword,
    releaseKeyAlias,
    releaseKeyPassword,
).all { !it.isNullOrBlank() }

android {
    namespace = "com.vittrade.vit_trade_flutter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.vittrade.vit_trade_flutter"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (hasReleaseSigning) {
                storeFile = file(releaseStoreFile!!)
                storePassword = releaseStorePassword
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
            }
        }
    }

    buildTypes {
        release {
            if (hasReleaseSigning) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

flutter {
    source = "../.."
}

gradle.taskGraph.whenReady {
    val requestsReleaseArtifact = allTasks.any {
        it.name.contains("Release")
    }
    if (requestsReleaseArtifact && !hasReleaseSigning) {
        throw GradleException(
            "Release signing is required. Configure android/key.properties "
                + "with storeFile, storePassword, keyAlias, and keyPassword, "
                + "or set VITTRADE_KEYSTORE_PATH, VITTRADE_KEYSTORE_PASSWORD, "
                + "VITTRADE_KEY_ALIAS, and VITTRADE_KEY_PASSWORD.",
        )
    }
}
