@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)

package com.example.checkout

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.autofill.ContentType
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.contentType
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.CancellationException

/** Host boundary only: this screen does not invent a checkout service. */
fun interface SaveCheckoutAddress { suspend fun save(address: CheckoutAddress): SaveAddressResult }

sealed interface SaveAddressResult {
    data object Saved : SaveAddressResult
    data class Failed(val message: String) : SaveAddressResult
}

@Composable
fun CheckoutAddressRoute(
    onBack: () -> Unit,
    onComplete: () -> Unit,
    saveAddress: SaveCheckoutAddress,
    countries: List<Country> = exampleCountries,
    modifier: Modifier = Modifier
) {
    require(countries.isNotEmpty()) { "Checkout requires at least one country." }
    var countryCode by rememberSaveable { mutableStateOf(countries.first().code) }
    val country = countries.firstOrNull { it.code == countryCode } ?: countries.first()
    var phone by rememberSaveable { mutableStateOf("") }
    var postalCode by rememberSaveable { mutableStateOf("") }
    var attemptedSubmit by rememberSaveable { mutableStateOf(false) }
    // Not saveable: recreation must never repeat a prior request.
    var submission by remember { mutableStateOf<SubmissionState>(SubmissionState.Idle) }
    val validation = validateCheckoutAddress(country, phone, postalCode)
    val submitting = submission is SubmissionState.Pending

    CheckoutAddressScreen(
        country = country, countries = countries, phone = phone, postalCode = postalCode,
        validation = if (attemptedSubmit) validation else AddressValidation(),
        submissionError = (submission as? SubmissionState.Failure)?.message,
        submitting = submitting, onBack = onBack,
        onCountryChanged = { countryCode = it.code; submission = SubmissionState.Idle },
        onPhoneChanged = { phone = it; submission = SubmissionState.Idle },
        onPostalCodeChanged = { postalCode = it; submission = SubmissionState.Idle },
        onContinue = {
            attemptedSubmit = true
            if (validation.isValid) submission = beginSubmission(
                submission, CheckoutAddress(country.code, phone.trim(), postalCode.trim())
            )
        }, modifier = modifier
    )

    val pending = submission as? SubmissionState.Pending
    if (pending != null) LaunchedEffect(pending.request) {
        try {
            when (val result = saveAddress.save(pending.request)) {
                SaveAddressResult.Saved -> { submission = submissionSucceeded(); onComplete() }
                is SaveAddressResult.Failed -> submission = submissionFailed(result.message)
            }
        } catch (cancelled: CancellationException) {
            submission = submissionCancelled()
            throw cancelled
        } catch (_: Exception) {
            submission = submissionFailed("Couldn’t save details. Try again.")
        }
    }
}

@Composable
fun CheckoutAddressScreen(
    country: Country,
    countries: List<Country>,
    phone: String,
    postalCode: String,
    validation: AddressValidation,
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
        topBar = { TopAppBar(
            title = { Text("Delivery details") },
            navigationIcon = { TextButton(onClick = onBack, enabled = !submitting) { Text("Back") } }
        ) },
        contentWindowInsets = WindowInsets.safeDrawing
    ) { innerPadding ->
        Column(
            modifier = Modifier.padding(innerPadding).imePadding().verticalScroll(rememberScrollState())
                .padding(horizontal = 16.dp).fillMaxSize(),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Spacer(Modifier.height(8.dp))
            Text("Where should we reach you?", style = MaterialTheme.typography.headlineSmall)
            Text("Example checkout form — country choices are sample data.",
                style = MaterialTheme.typography.bodyLarge, color = MaterialTheme.colorScheme.onSurfaceVariant)
            Text("Contact", style = MaterialTheme.typography.titleMedium)
            OutlinedButton(
                onClick = { countryPickerOpen = true }, enabled = !submitting,
                modifier = Modifier.fillMaxWidth().heightIn(min = 52.dp), contentPadding = PaddingValues(horizontal = 16.dp)
            ) { Text("Country: ${country.name} (${country.dialCode})") }
            OutlinedTextField(
                value = phone, onValueChange = onPhoneChanged,
                modifier = Modifier.fillMaxWidth().semantics { contentType = ContentType.PhoneNumberNational },
                label = { Text("Phone number") }, prefix = { Text(country.dialCode) }, singleLine = true,
                enabled = !submitting, isError = validation.phoneError != null,
                supportingText = { Text(validation.phoneError ?: "Include the local number, without the country code.") },
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone, imeAction = ImeAction.Next)
            )
            OutlinedTextField(
                value = postalCode, onValueChange = onPostalCodeChanged,
                modifier = Modifier.fillMaxWidth().semantics { contentType = ContentType.PostalCode },
                label = { Text(if (country.postalCodeRequired) "Postal code" else "Postal code (optional)") },
                singleLine = true, enabled = !submitting, isError = validation.postalCodeError != null,
                supportingText = { Text(validation.postalCodeError ?: if (country.postalCodeRequired) "Required for ${country.name}." else "Optional for ${country.name}.") },
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Text, imeAction = ImeAction.Done)
            )
            if (submissionError != null) Text(submissionError,
                modifier = Modifier.semantics { liveRegion = LiveRegionMode.Assertive },
                color = MaterialTheme.colorScheme.error, style = MaterialTheme.typography.bodyMedium)
            Button(onClick = onContinue, enabled = !submitting,
                modifier = Modifier.fillMaxWidth().heightIn(min = 52.dp), contentPadding = PaddingValues(horizontal = 24.dp)) {
                if (submitting) {
                    CircularProgressIndicator(
                        modifier = Modifier.width(20.dp).height(20.dp),
                        strokeWidth = 2.dp,
                        color = MaterialTheme.colorScheme.onPrimary
                    )
                    Spacer(Modifier.width(8.dp)); Text("Saving details")
                } else Text("Continue")
            }
            Spacer(Modifier.height(16.dp))
        }
    }
    if (countryPickerOpen) AlertDialog(
        onDismissRequest = { countryPickerOpen = false }, title = { Text("Choose country") },
        text = { Column { countries.forEach { option ->
            TextButton(onClick = { onCountryChanged(option); countryPickerOpen = false }, modifier = Modifier.fillMaxWidth()) {
                Text("${option.name} (${option.dialCode})")
            }; HorizontalDivider()
        } } },
        confirmButton = { TextButton(onClick = { countryPickerOpen = false }) { Text("Cancel") } }
    )
}
