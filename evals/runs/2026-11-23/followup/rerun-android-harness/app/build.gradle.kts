plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.plugin.compose")
}

android {
    namespace = "com.example.checkout"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.checkout.harness"
        minSdk = 23
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
    }
    buildFeatures { compose = true }
    sourceSets.named("main") {
        kotlin.directories.add(rootProject.layout.projectDirectory.dir("../rerun-4").asFile.path)
    }
}

dependencies {
    implementation(platform("androidx.compose:compose-bom:2025.06.01"))
    implementation("androidx.activity:activity-compose:1.10.1")
    implementation("androidx.compose.material3:material3")
    testImplementation("junit:junit:4.13.2")
}

