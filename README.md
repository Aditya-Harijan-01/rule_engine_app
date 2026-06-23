# Rule Engine App

A Flutter application for building, executing, and auditing business rules with Firebase-backed storage and GetX navigation.

# Flutter & Firebase CLI Setup

## Prerequisites

Install the following:

### Flutter SDK

This project was developed and tested with:

```bash
Flutter 3.41.4 • channel stable
Framework • revision ff37bef603
Dart 3.11.1
```

Verify installation:

```bash
flutter --version
flutter doctor
```

Ensure all Flutter Doctor checks pass before continuing.

### Firebase CLI

Install Firebase CLI globally:

```bash
npm install -g firebase-tools
```

Verify installation:

```bash
firebase --version
```

Login to Firebase:

```bash
firebase login
```

### FlutterFire CLI

Install FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
```

Verify installation:

```bash
flutterfire --version
```


---

## Clone the Project

```bash
git clone <repository-url>
cd rule_engine_app
```

Install dependencies:

```bash
flutter pub get
```

---

## Create Firebase Project

1. Open Firebase Console.
2. Click **Create Project**.
3. Enter a project name.
4. Enable Google Analytics (optional).
5. Create the project.

---

## Enable Authentication

Navigate to:

```text
Firebase Console
→ Authentication
→ Sign-in Method
→ Email/Password
```

Enable:

```text
Email/Password Authentication
```

---

## Create Firestore Database

Navigate to:

```text
Firebase Console
→ Firestore Database
```

Create a database in:

```text
Production Mode
```

Select the closest region to your users.

---

## Configure FlutterFire

From the project root:

```bash
flutterfire configure
```

Select:

* Firebase Project
* Android App
* iOS App
* Web App (optional)

The command generates:

```text
lib/firebase_options.dart
```

This file is required by the application.

---

## Android Configuration

Ensure the generated file exists:

```text
android/app/google-services.json
```

Verify the following plugin exists in:

```gradle
android/app/build.gradle.kts
```

```kotlin
plugins {
    id("com.google.gms.google-services")
}
```

---

## iOS Configuration

For iOS, ensure:

```text
ios/Runner/GoogleService-Info.plist
```

exists after FlutterFire configuration.

Install CocoaPods dependencies:

```bash
cd ios
pod install
cd ..
```

---

## Firestore Data Structure

The application stores user data under:

```text
users/{uid}/rules
users/{uid}/executions
```

Example:

```text
users
 └─ userId
     ├─ rules
     │   └─ ruleDocument
     └─ executions
         └─ executionDocument
```

---

## Run the Application

Start the app:

```bash
flutter run
```

For a specific device:

```bash
flutter devices

flutter run -d <device-id>
```

---

## Build Release APK

```bash
flutter build apk --release
```

Build App Bundle:

```bash
flutter build appbundle --release
```

---

## Build iOS Release

```bash
flutter build ios --release
```

or

```bash
flutter build ipa
```

---

## Common Issues

### Firebase Not Initialized

Ensure:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

exists in `main.dart`.

### flutterfire Command Not Found

Reinstall FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
```

and ensure the pub-cache bin directory is added to PATH.

### Firestore Permission Denied

Verify Authentication is enabled and Firestore Security Rules allow authenticated users to access only their own data.

Example development rule:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null &&
                         request.auth.uid == userId;
    }
  }
}
```

---

## Environment Used

```text
Flutter 3.41.4
Dart 3.11.1
Firebase Auth
Cloud Firestore
GetX
GetStorage
```


## Overview

This app provides a workflow for:
- user authentication via Firebase Auth
- creating and managing business automation rules
- executing events against active rules
- storing execution history in Firestore

The app uses GetX for routing, state management, and dependency injection.

## Key Features

- Sign in and sign up with Firebase Auth
- Rule listing, editing, activation, and deletion
- Rule editor with conditions and actions
- Execute a JSON event payload to trigger matching rules
- Track executed events with triggered rules and produced actions

## App Structure

### Main entry point

- `lib/main.dart`
  - initializes Firebase and GetStorage
  - starts the app with `GetMaterialApp`
  - uses `AppPages.routes` for navigation

### Routes

Configured in `lib/app/routes/app_pages.dart` and `lib/app/routes/app_routes.dart`:
- `/` → `SplashScreenView`
- `/auth-page` → `AuthPageView`
- `/rule-page` → `RulePageView`
- `/execute-event` → `ExecuteEventView`
- `/history` → `HistoryView`
- `/rule-editor` → `RuleEditorView`

### Modules

- `lib/app/modules/auth_page/` — login and registration
- `lib/app/modules/home/` — dashboard navigation cards
- `lib/app/modules/rule_page/` — rule list and actions
- `lib/app/modules/rule_editor/` — create/edit rule details
- `lib/app/modules/execute_event/` — event execution UI
- `lib/app/modules/history/` — execution history viewer
- `lib/app/modules/splash_screen/` — startup splash and redirect logic

## Screens

### Splash Screen

- `lib/app/modules/splash_screen/views/splash_screen_view.dart`
- Shows brand title and loading state
- After a delay, checks `GetStorage` login state
- Redirects to either `HOME` or `AUTH_PAGE`

### Auth Page

- `lib/app/modules/auth_page/views/auth_page_view.dart`
- `AuthPageController` handles Firebase Auth
- Users can toggle between register and login modes
- Stores user info locally using `GetStorage`
- Upon successful login, navigates to home

### Home Page

- `lib/app/modules/home/views/home_view.dart`
- Dashboard with cards for:
  - Rules
  - Execute Event
  - History
  - Profile (sign-out)

### Rule Page

- `lib/app/modules/rule_page/views/rule_page_view.dart`
- Lists all business rules from Firestore
- Supports search UI placeholder and add rule button
- Rule cards show active/inactive state, conditions, actions
- Edit uses `RuleEditorView`
- Save and toggle activation through `RulePageController`

### Rule Editor

- `lib/app/modules/rule_editor/views/rule_editor_view.dart`
- `RuleEditorController` manages rule form state
- Supports:
  - rule name
  - priority level
  - active / inactive status
  - multiple conditions
  - multiple actions
- Conditions include field, operator, and expected value
- Actions include type and output value
- Saves the rule back to Firestore via rule repository

### Execute Event

- `lib/app/modules/execute_event/views/execute_event_view.dart`
- `ExecuteEventController` loads rules and runs JSON payloads
- Input payload is parsed as JSON and executed against active rules
- Shows loading, error, or result card after execution
- Displays triggered rules and produced actions

### History

- `lib/app/modules/history/views/history_view.dart`
- Uses `HistoryController` and `HistoryRepository`
- Displays event execution records from Firestore
- Shows input payload, triggered rules, actions, and timestamp

## Data Models

### Rule Model

Defined in `lib/app/data/models/rule.dart`:
- `BusinessRule`
  - `id`, `name`, `conditions`, `actions`, `isActive`, `priority`
- `RuleCondition`
  - `field`, `operator`, `value`
- `RuleAction`
  - `type`, `value`
- `RuleOperator`
  - operators such as `equals`, `notEquals`, `greaterThan`, `lessThan`, `contains`, `exists`

### Execution Record

Defined in `lib/app/data/models/execution_record.dart`:
- `ExecutionRecord`
  - `id`, `event`, `triggeredRuleNames`, `actions`, `executedAt`, `success`

### Execution Result

Defined in `lib/app/data/repositories/rule_engine.dart`:
- `RuleExecutionResult`
  - triggered rules and aggregated actions after execution

## Repositories

### RuleRepository

- `lib/app/data/repositories/rule_repository.dart`
- Uses Firestore to store and retrieve rules under the signed-in user
- Provides `watchAll()` stream for live rule updates
- Supports save, delete, and active toggle operations

### HistoryRepository

- `lib/app/data/repositories/history_repository.dart`
- Stores execution history under `users/{uid}/executions`
- Records event payload, triggered rule IDs, action map, success, and timestamp

### RuleEngine

- `lib/app/data/repositories/rule_engine.dart`
- Evaluates active rules against incoming event payloads
- Orders rules by descending priority
- Triggers rules only when all conditions match
- Aggregates all actions from triggered rules
- Supports path reading for nested JSON via dot notation

## Firebase Integration

The app expects Firebase configuration in `lib/firebase_options.dart`.

Required services:
- Firebase Auth
- Cloud Firestore

Firestore data layout:
- `users/{uid}/rules` — saved business rules
- `users/{uid}/executions` — execution history records

## Setup

1. Install Flutter and set up your environment.
2. Open the project folder in VS Code or another editor.
3. Run `flutter pub get` to install dependencies.
4. Configure Firebase and generate `firebase_options.dart`.
5. Run the app with `flutter run`.

## Development Notes

- Navigation is handled with GetX routes in `AppPages.routes`.
- Controllers use `GetxController` and `GetBuilder` for UI updates.
- The rule editor initializes with either a blank rule or an existing rule for editing.
- Rule execution expects valid JSON in the payload field.

## Extending the App

To add new rule operators:
1. Add a value to `RuleOperator` in `lib/app/data/models/rule.dart`.
2. Update `rule_engine.dart` to implement the operator logic.
3. Add UI support in `rule_editor_view.dart` if necessary.

To add new action behavior:
1. Extend `RuleAction` or add action type handling in execution result presentation.
2. Update the history UI to capture any new action fields.

## Troubleshooting

- If authentication fails, verify Firebase Auth is enabled and your config is correct.
- If rules do not execute, ensure event payload is valid JSON and active rules have matching condition fields.
- If history is empty, confirm Firestore writes are succeeding and that `executedAt` timestamp values exist.

## File Reference

- `lib/main.dart` — app bootstrap
- `lib/app/routes/app_pages.dart` — routing
- `lib/app/modules/*` — feature modules
- `lib/app/data/*` — models and data access
- `lib/app/core/async_state.dart` — shared async state helper

## License

This project is currently private and not configured for pub publishing.
