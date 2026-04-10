🍎 Predictive Pantry Planner
Zero-Waste Cooking powered by On-Device Intelligence.

Predictive Pantry Planner is a high-performance Flutter application designed to bridge the gap between food waste and culinary creativity. By leveraging computer vision and on-device LLMs, the app identifies ingredients, tracks expiration dates, and suggests recipes based strictly on what you already own.

🚀 Key Features
Real-time Vision Scanning: Instant ingredient recognition using optimized on-device models.

Intelligent Waste Mitigation: A proprietary ranking logic that prioritizes ingredients nearing their expiration date.

Privacy-First AI: All reasoning is performed locally via Gemini Nano—no data leaves your device.

Contextual Recipes: Recipe suggestions that respect your current inventory, avoiding the "missing ingredient" frustration.

Minimalist UI: A clean, contemporary interface focused on speed and high-utility kitchen interactions.

🛠 Tech Stack
The project is built entirely on free, cutting-edge technologies to ensure scalability without overhead:

Layer	Technology
Frontend	Flutter (Clean Architecture + MVI)
Computer Vision	TensorFlow Lite / PyTorch Mobile
On-Device LLM	Gemini Nano (Google AI Edge SDK)
Data Source	OpenFoodFacts / Spoonacular API
Local Storage	Drift (SQLite) for high-performance reactive persistence
🏗 Architecture
The app follows Clean Architecture principles to ensure the business logic is decoupled from the UI and external frameworks.

Data Layer: Handles camera streams, API calls, and local database management.

Domain Layer: Contains the "Waste Mitigation" logic and repository interfaces.

Presentation Layer: Implemented using a reactive MVI (Model-View-Intent) pattern for predictable state management in a multi-modal (Vision + Text) environment.

🚦 Getting Started
Prerequisites

Flutter SDK ^3.x

Android Studio / Xcode

An Android device compatible with Google AI Edge (for Gemini Nano features)

Installation

Clone the repository:

Bash
git clone https://github.com/your-username/predictive-pantry-planner.git
Install dependencies:

Bash
flutter pub get
Download the TFLite Model:
Place your trained ingredients_v1.tflite model and labels.txt in the assets/models/ directory.

Run the application:

Bash
flutter run --release
🗺 Roadmap
[ ] Phase 1: CV Model integration for top 50 common household ingredients.

[ ] Phase 2: Gemini Nano implementation for offline recipe generation.

[ ] Phase 3: Expiration date OCR (Optical Character Recognition) refinement.

[ ] Phase 4: Global recipe API integration for diverse dietary preferences.
