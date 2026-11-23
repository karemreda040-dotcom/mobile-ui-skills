package com.example.checkout

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material3.MaterialTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                CheckoutAddressRoute(
                    onBack = {},
                    onComplete = {},
                    saveAddress = SaveCheckoutAddress { SaveAddressResult.Saved }
                )
            }
        }
    }
}
