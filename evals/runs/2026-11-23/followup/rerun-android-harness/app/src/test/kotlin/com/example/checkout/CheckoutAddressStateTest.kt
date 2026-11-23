package com.example.checkout

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class CheckoutAddressStateTest {
    private val required = Country("Required", "R", "+1", postalCodeRequired = true)
    private val optional = Country("Optional", "O", "+2", postalCodeRequired = false)
    private val address = CheckoutAddress("R", "5551234", "12345")

    @Test fun requiredPostalCodeIsValidated() {
        assertEquals("Enter a postal code for Required.", validateCheckoutAddress(required, "5551234", "").postalCodeError)
    }

    @Test fun optionalPostalCodeMayBeBlank() {
        assertTrue(validateCheckoutAddress(optional, "5551234", "").isValid)
    }

    @Test fun failureCanRetryIntoPending() {
        assertEquals(SubmissionState.Pending(address), beginSubmission(submissionFailed("offline"), address))
    }

    @Test fun duplicatePendingSubmissionKeepsOriginalSnapshot() {
        val pending = SubmissionState.Pending(address)
        assertEquals(pending, beginSubmission(pending, address.copy(phone = "different")))
    }

    @Test fun successClearsSubmissionState() {
        assertEquals(SubmissionState.Idle, submissionSucceeded())
    }

    @Test fun cancellationClearsSubmissionState() {
        assertEquals(SubmissionState.Idle, submissionCancelled())
    }

    @Test fun blankPhoneIsInvalid() {
        assertFalse(validateCheckoutAddress(optional, " ", "").isValid)
    }
}
