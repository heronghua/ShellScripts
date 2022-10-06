#================================================================
# File Name: AndroidApplicationGen.sh
# Author: He Ronghua
# mail: heronghua1989@126.com
# Created Time: 2022年06月12日 星期日 07时50分05秒
#================================================================
#!/bin/bash

read -p "Please input your ProjectName:" ProjectName
read -p "Please input your package name:" PackageName

mkdir -p $ProjectName/src/`echo $PackageName|sed 'y/./\//'` $ProjectName/res

cat > $ProjectName/build.gradle << EOF
// Top-level build file where you can add configuration options common to all sub-projects/modules.

buildscript {
    repositories {
        jcenter()
        google()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:4.0.1'

        // NOTE: Do not place your application dependencies here; they belong
        // in the individual module build.gradle files
    }
}

allprojects {
    repositories {
        jcenter()
        google()
    }
}

apply plugin: 'com.android.application'

android {
    compileSdkVersion 28
    buildToolsVersion "28.0.3"
    defaultConfig {
        applicationId "$PackageName"
        minSdkVersion 21
        targetSdkVersion 28
        versionCode 1
        versionName "1.0"

        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard.flags'
        }
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    sourceSets {
        main {
            res.srcDirs = ['res']
            java.srcDirs = ['src']
            jniLibs.srcDirs = ['libs']
            aidl.srcDirs = ['aidl']
            manifest.srcFile 'AndroidManifest.xml'

        }

        

    }
}

dependencies {

    implementation fileTree(dir: 'libs', include: ['*.jar'])

    implementation 'com.android.support:appcompat-v7:28.0.0'

    //===============================test library=============================================
    testImplementation 'junit:junit:4.12'
    // Set this dependency to build and run UI Automator tests
    androidTestImplementation 'com.android.support.test.uiautomator:uiautomator-v18:2.1.3'

    // Core library
    androidTestImplementation 'androidx.test:core:1.2.0'

    // AndroidJUnitRunner and JUnit Rules
    androidTestImplementation 'androidx.test:runner:1.2.0'
    androidTestImplementation 'androidx.test:rules:1.1.1'

    // Assertions
    androidTestImplementation 'androidx.test.ext:junit:1.1.1'
    androidTestImplementation 'androidx.test.ext:truth:1.1.0'
    androidTestImplementation 'com.google.truth:truth:0.42'

    // Espresso dependencies
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.2.0'
    androidTestImplementation 'androidx.test.espresso:espresso-contrib:3.1.1'
    androidTestImplementation 'androidx.test.espresso:espresso-intents:3.1.1'
    androidTestImplementation 'androidx.test.espresso:espresso-accessibility:3.1.1'
    androidTestImplementation 'androidx.test.espresso:espresso-web:3.1.1'
    androidTestImplementation 'androidx.test.espresso.idling:idling-concurrent:3.1.1'

    // The following Espresso dependency can be either "implementation"
    // or "androidTestImplementation", depending on whether you want the
    // dependency to appear on your APK's compile classpath or the test APK
    // classpath.
    androidTestImplementation 'androidx.test.espresso:espresso-idling-resource:3.2.0'
    //====================================================================================
}
EOF

cat > $ProjectName/AndroidManifest.xml << EOF
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="$PackageName">

    <uses-sdk android:targetSdkVersion="23" android:minSdkVersion="29"/>

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.$ProjectName">
        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
EOF

