package com.example.checkout

data class Country(
    val name: String,
    val code: String,
    val dialCode: String,
    val postalCodeRequired: Boolean
)

/** Example-only fallback for previews; the checkout host should provide its real catalog. */
val exampleCountries = listOf(
    Country("United States", "US", "+1", postalCodeRequired = true),
    Country("United Kingdom", "GB", "+44", postalCodeRequired = true),
    Country("Egypt", "EG", "+20", postalCodeRequired = false)
)

data class CheckoutAddress(val countryCode: String, val phone: String, val postalCode: String)

data class AddressValidation(val phoneError: String? = null, val postalCodeError: String? = null) {
    val isValid get() = phoneError == null && postalCodeError == null
}

fun validateCheckoutAddress(country: Country, phone: String, postalCode: String): AddressValidation =
    AddressValidation(
        phoneError = if (phone.trim().isEmpty()) "Enter a phone number." else null,
        postalCodeError = when {
            country.postalCodeRequired && postalCode.trim().isEmpty() -> "Enter a postal code for ${country.name}."
            else -> null
        }
    )

sealed interface SubmissionState {
    data object Idle : SubmissionState
    data class Pending(val request: CheckoutAddress) : SubmissionState
    data class Failure(val message: String) : SubmissionState
}

/** Ignores duplicate submission requests while one immutable request is already pending. */
fun beginSubmission(state: SubmissionState, request: CheckoutAddress): SubmissionState =
    if (state is SubmissionState.Pending) state else SubmissionState.Pending(request)

fun submissionFailed(message: String): SubmissionState = SubmissionState.Failure(message)

/** Success clears transient submission state before the host advances checkout. */
fun submissionSucceeded(): SubmissionState = SubmissionState.Idle

/** Cancellation also clears the local pending marker; the caller must then rethrow it. */
fun submissionCancelled(): SubmissionState = SubmissionState.Idle
