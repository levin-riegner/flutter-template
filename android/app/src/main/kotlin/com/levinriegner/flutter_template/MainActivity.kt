package com.levinriegner.flutter_template

import android.os.Build
import android.os.Bundle
import android.window.SplashScreenView
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        // region Android 12 SplashScreen
        // Aligns the Flutter view vertically with the window.
        WindowCompat.setDecorFitsSystemWindows(window, false)
        val splashScreen = installSplashScreen()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Disable the Android splash screen fade out animation to avoid
            // a flicker before the similar frame is drawn in Flutter.
            splashScreen
                .setOnExitAnimationListener { splashScreenProvider ->
                    splashScreenProvider.remove()
                }
        }
        // endregion
        super.onCreate(savedInstanceState)
    }
}
