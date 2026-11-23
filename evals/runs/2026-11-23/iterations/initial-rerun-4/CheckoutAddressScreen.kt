@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)

package com.example.checkout

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.safeDrawing

/** A small boundary for the host's real checkout/use-case layer; no service is assumed here. */
fun interface SaveCheckoutAddress {
    suspend fun save(address: CheckoutAddress): SaveAddressResult
}

data class CheckoutAddress(val countryCode: String, val phone: String, val postalCode: String)

sealed interface SaveAddressResult {
    data object Saved : SaveAddressResult
    data class Failed(val message: String) : SaveAddressResult
}

data class Country(val name: String, val code: String, val dialCode: String)
private val countries = listOf(
    Country("United States", "US", "+1"),
    Country("United Kingdom", "GB", "+44"),
    Country("Egypt", "EG", "+20")
)

@Composable
fun CheckoutAddressRoute(
    onBack: () -> Unit,
    onComplete: () -> Unit,
    saveAddress: SaveCheckoutAddress,
    modifier: Modifier = Modifier
) {
    var countryCode by rememberSaveable { mutableStateOf(countries.first().code) }
    val country = countries.first { it.code == countryCode }
    var phone by rememberSaveable { mutableStateOf("") }
    var postalCode by rememberSaveable { mutableStateOf("") }
    var attemptedSubmit by rememberSaveable { mutableStateOf(false) }
    var submitting by rememberSaveable { mutableStateOf(false) }
    var submissionError by rememberSaveable { mutableStateOf<String?>(null) }

    val phoneError = attemptedSubmit && phone.trim().isEmpty()
    val postalError = attemptedSubmit && postalCode.trim().isEmpty()
    CheckoutAddressScreen(
        country = country,
        phone = phone,
        postalCode = postalCode,
        phoneError = phoneError,
        postalError = postalError,
        submissionError = submissionError,
        submitting = submitting,
        onBack = onBack,
        onCountryChanged = { countryCode = it.code; submissionError = null },
        onPhoneChanged = { phone = it; submissionError = null },
        onPostalCodeChanged = { postalCode = it; submissionError = null },
        onContinue = {
            attemptedSubmit = true
            if (phone.trim().isNotEmpty() && postalCode.trim().isNotEmpty()) {
                submitting = true
                submissionError = null
            }
        },
        modifier = modifier
    )

    // This explicit boundary belongs in a ViewModel/coroutine owner in an app.
    // Kept here as source-only reference because no project lifecycle scope exists.
    if (submitting) {
        LaunchedEffect(country, phone, postalCode) {
            when (val result = saveAddress.save(CheckoutAddress(country.code, phone.trim(), postalCode.trim()))) {
                SaveAddressResult.Saved -> onComplete()
                is SaveAddressResult.Failed -> {
                    submissionError = result.message
                    submitting = false
                }
            }
        }
    }
}

@Composable
fun CheckoutAddressScreen(
    country: Country,
    phone: String,
    postalCode: String,
    phoneError: Boolean,
    postalError: Boolean,
    submissionError: String?,
    submitting: Boolean,
    onBack: () -> Unit,
    onCountryChanged: (Country) -> Unit,
    onPhoneChanged: (String) -> Unit,
    onPostalCodeChanged: (String) -> Unit,
    onContinue: () -> Unit,
    modifier: Modifier = Modifier
) {
    var countryPickerOpen by remember { mutableStateOf(false) }
    Scaffold(
        modifier = modifier.fillMaxSize(),
        topBar = {
            TopAppBar(
                title = { Text("Delivery details") },
                navigationIcon = { TextButton(onClick = onBack) { Text("Back") } }
            )
        },
        contentWindowInsets = WindowInsets.safeDrawing
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .padding(innerPadding)
                .imePadding()
                .padding(horizontal = 16.dp)
                .fillMaxSize(),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Spacer(Modifier.height(8.dp))
            Text("Where should we reach you?", style = MaterialTheme.typography.headlineSmall)
            Text(
                "We’ll use these details only for delivery updates.",
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )

            Text("Contact", style = MaterialTheme.typography.titleMedium)
            OutlinedTextField(
                value = country.name,
                onValueChange = {},
                modifier = Modifier.fillMaxWidth().then(
                    if (!submitting) Modifier.clickable { countryPickerOpen = true } else Modifier
                ),
                label = { Text("Country") },
                readOnly = true,
                enabled = !submitting,
                trailingIcon = { Text("Change") },
                supportingText = { Text("Sets the calling code and postal-code rules.") }
            )
            OutlinedTextField(
                value = phone,
                onValueChange = onPhoneChanged,
                modifier = Modifier.fillMaxWidth(),
                label = { Text("Phone number") },
                prefix = { Text(country.dialCode) },
                singleLine = true,
                enabled = !submitting,
                isError = phoneError,
                supportingText = {
                    Text(if (phoneError) "Enter a phone number for delivery updates." else "Include the local number, without the country code.")
                },
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone, imeAction = ImeAction.Next)
            )
            OutlinedTextField(
                value = postalCode,
                onValueChange = onPostalCodeChanged,
                modifier = Modifier.fillMaxWidth(),
                label = { Text("Postal code") },
                singleLine = true,
                enabled = !submitting,
                isError = postalError,
                supportingText = { Text(if (postalError) "Enter the postal code for ${country.name}." else "Format varies by country.") },
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Text, imeAction = ImeAction.Done)
            )
            if (submissionError != null) {
                Text(
                    submissionError,
                    modifier = Modifier.semantics { liveRegion = LiveRegionMode.Assertive },
                    color = MaterialTheme.colorScheme.error,
                    style = MaterialTheme.typography.bodyMedium
                )
            }
            Spacer(Modifier.weight(1f))
            Button(
                onClick = onContinue,
                enabled = !submitting,
                modifier = Modifier.fillMaxWidth().height(52.dp),
                contentPadding = PaddingValues(horizontal = 24.dp)
            ) {
                if (submitting) {
                    CircularProgressIndicator(
                        modifier = Modifier.width(20.dp).height(20.dp),
                        strokeWidth = 2.dp,
                        color = MaterialTheme.colorScheme.onPrimary
                    )
                    Spacer(Modifier.width(8.dp))
                    Text("Saving details")
                } else Text("Continue")
            }
        }
    }

    if (countryPickerOpen) {
        AlertDialog(
            onDismissRequest = { countryPickerOpen = false },
            title = { Text("Choose country") },
            text = {
                Column {
                    countries.forEach { option ->
                        TextButton(
                            onClick = { onCountryChanged(option); countryPickerOpen = false },
                            modifier = Modifier.fillMaxWidth()
                        ) { Text("${option.name} (${option.dialCode})") }
                        HorizontalDivider()
                    }
                }
            },
            confirmButton = { TextButton(onClick = { countryPickerOpen = false }) { Text("Cancel") } }
        )
    }
}
