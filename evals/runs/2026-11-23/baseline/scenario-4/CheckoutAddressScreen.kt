@file:OptIn(ExperimentalMaterial3Api::class)

package evaluation.checkout

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawingPadding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ExposedDropdownMenuBox
import androidx.compose.material3.ExposedDropdownMenuDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.dropdownMenuItem
import androidx.compose.material3.ExposedDropdownMenu
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.semantics.LiveRegionMode
import androidx.compose.ui.semantics.liveRegion
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextDirection
import androidx.compose.ui.unit.dp

/** UI-only model. The caller owns persistence, analytics, and navigation. */
data class CheckoutAddress(
    val country: Country? = null,
    val phone: String = "",
    val postalCode: String = "",
)

data class Country(val isoCode: String, val name: String, val callingCode: String)

data class AddressFieldErrors(
    val country: String? = null,
    val phone: String? = null,
    val postalCode: String? = null,
)

sealed interface SubmitState {
    data object Idle : SubmitState
    data object Submitting : SubmitState
    data class Failure(val message: String) : SubmitState
}

/**
 * Integration boundary: call the checkout/domain layer here. It is deliberately suspend so the
 * host can show a real in-flight state and prevent duplicate submissions without a fake service.
 */
typealias SubmitCheckoutAddress = suspend (CheckoutAddress) -> Result<Unit>

@Composable
fun CheckoutAddressScreen(
    countries: List<Country>,
    address: CheckoutAddress,
    errors: AddressFieldErrors,
    submitState: SubmitState,
    onAddressChanged: (CheckoutAddress) -> Unit,
    onContinue: () -> Unit,
    modifier: Modifier = Modifier,
) {
    var countryMenuExpanded by remember { mutableStateOf(false) }
    val submitting = submitState is SubmitState.Submitting
    val statusMessage = (submitState as? SubmitState.Failure)?.message

    Column(
        modifier = modifier
            .fillMaxSize()
            .safeDrawingPadding()
            .imePadding()
            .verticalScroll(rememberScrollState())
            .padding(horizontal = 16.dp, vertical = 24.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
    ) {
        Text("Delivery address", style = MaterialTheme.typography.headlineSmall)
        Text(
            "We use these details to confirm delivery options.",
            style = MaterialTheme.typography.bodyLarge,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )

        ExposedDropdownMenuBox(
            expanded = countryMenuExpanded,
            onExpandedChange = { countryMenuExpanded = !countryMenuExpanded },
        ) {
            OutlinedTextField(
                value = address.country?.name.orEmpty(),
                onValueChange = {},
                readOnly = true,
                label = { Text("Country") },
                placeholder = { Text("Choose country") },
                isError = errors.country != null,
                supportingText = errors.country?.let { { Text(it) } },
                trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(countryMenuExpanded) },
                modifier = Modifier
                    .menuAnchor()
                    .fillMaxWidth()
                    .testTag("checkout_country"),
            )
            ExposedDropdownMenu(
                expanded = countryMenuExpanded,
                onDismissRequest = { countryMenuExpanded = false },
            ) {
                countries.forEach { country ->
                    androidx.compose.material3.DropdownMenuItem(
                        text = { Text(country.name) },
                        onClick = {
                            onAddressChanged(address.copy(country = country))
                            countryMenuExpanded = false
                        },
                    )
                }
            }
        }

        OutlinedTextField(
            value = address.phone,
            onValueChange = { onAddressChanged(address.copy(phone = it)) },
            label = { Text("Phone number") },
            placeholder = { Text("Phone number") },
            prefix = address.country?.let { { Text(it.callingCode) } },
            isError = errors.phone != null,
            supportingText = errors.phone?.let { { Text(it) } },
            keyboardOptions = KeyboardOptions(
                keyboardType = KeyboardType.Phone,
                imeAction = ImeAction.Next,
            ),
            modifier = Modifier
                .fillMaxWidth()
                .testTag("checkout_phone"),
            textStyle = MaterialTheme.typography.bodyLarge.copy(textDirection = TextDirection.ContentOrLtr),
        )

        OutlinedTextField(
            value = address.postalCode,
            onValueChange = { onAddressChanged(address.copy(postalCode = it)) },
            label = { Text("Postal code") },
            placeholder = { Text("Postal code") },
            isError = errors.postalCode != null,
            supportingText = errors.postalCode?.let { { Text(it) } },
            keyboardOptions = KeyboardOptions(
                keyboardType = KeyboardType.Text,
                imeAction = ImeAction.Done,
            ),
            modifier = Modifier
                .fillMaxWidth()
                .testTag("checkout_postal_code"),
            textStyle = MaterialTheme.typography.bodyLarge.copy(textDirection = TextDirection.ContentOrLtr),
        )

        statusMessage?.let {
            Text(
                text = it,
                color = MaterialTheme.colorScheme.error,
                style = MaterialTheme.typography.bodyMedium,
                modifier = Modifier.liveRegion(LiveRegionMode.Assertive).testTag("checkout_submit_error"),
            )
        }

        Button(
            onClick = onContinue,
            enabled = !submitting,
            modifier = Modifier
                .fillMaxWidth()
                .heightIn(min = 52.dp)
                .testTag("checkout_continue"),
        ) {
            if (submitting) {
                CircularProgressIndicator(
                    modifier = Modifier.padding(end = 8.dp),
                    strokeWidth = 2.dp,
                    color = MaterialTheme.colorScheme.onPrimary,
                )
                Text("Saving address")
            } else {
                Text("Continue")
            }
        }
    }
}

fun validateAddress(address: CheckoutAddress): AddressFieldErrors = AddressFieldErrors(
    country = if (address.country == null) "Choose a country to continue." else null,
    phone = if (address.phone.trim().length < 4) "Enter a phone number." else null,
    postalCode = if (address.postalCode.isBlank()) "Enter a postal code." else null,
)
