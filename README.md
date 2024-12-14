Jokes App 📱
A Flutter application designed to fetch jokes from an online API and cache them locally for offline use. This app showcases efficient API integration, caching with shared_preferences, and proper handling of online/offline scenarios while maintaining a clean and responsive UI.

📋 Features
Online Mode:
Fetches and displays 5 jokes from an API using an HTTP GET request.

Offline Mode:
Displays locally cached jokes when no internet connection is available, ensuring a seamless user experience.

Data Caching:
Uses the shared_preferences package to store jokes for offline use.

JSON Handling:
Properly serializes and deserializes joke data for storage and retrieval.

Error Handling:
Provides fallback mechanisms for API errors and network unavailability.

🛠️ Technologies Used
Framework: Flutter
Networking: HTTP (http package)
Caching: Shared Preferences (shared_preferences package)
State Management: setState

🚀 How to Run
Clone the Repository:

bash
Copy code
git clone https://github.com/yourusername/JokesApp.git
Unzip the Flutter Project:
Extract the contents of flutter_project.zip.

Set Up Your Environment:
Ensure you have Flutter installed and set up. Run:

bash
Copy code
flutter doctor
Install Dependencies:
Navigate to the project directory and run:

bash
Copy code
flutter pub get
Run the App:
Launch the app on an emulator or connected device:

bash
Copy code
flutter run
