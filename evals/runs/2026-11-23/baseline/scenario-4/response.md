# Scenario 4 response

Created a minimal, integration-ready Jetpack Compose checkout address screen in `CheckoutAddressScreen.kt`, plus integration/state guidance in `README.md`.

Platform decisions: Material 3 components, `dp` layout / theme typography, system safe-area and IME insets, vertically scrollable content for font scaling, persistent input labels, correct phone IME, and one 48 dp+ primary action. The caller supplies countries and a suspend submit boundary; no backend or fake checkout service was added.

Actual checks performed:

- `find …/scenario-4 -maxdepth 2 -type f -print`: no existing project/app files were present before the artifact.
- `command -v gradle` and `command -v kotlinc`: both returned no executable.
- `command -v java`: Java 17 is installed, but it cannot compile Compose without an Android/Gradle project and dependencies.
- Manual source inspection: screen includes country, phone, postal code, Continue, input errors, submitting state, failure announcement, IME/safe-area handling, and test tags.

Not performed / limitation:

- No Gradle project, Compose compiler, emulator, or device was supplied, so compilation, Material rendering, TalkBack, RTL/large-font visual inspection, and automated UI tests could not be run. The host must wire resources, ViewModel focus requests, and the actual checkout submission implementation.
