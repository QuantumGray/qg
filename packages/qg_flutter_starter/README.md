# $NAME

![coverage][coverage_badge]

Project $NAME created by QuantumGray

---

## Getting Started 🚀

setup:

- to reinitialize the submodules '.vscode' and 'hooks' please run `git submodule update --init --recursive -j 2`
- run `flutter pub run build_runner build --delete-conflicting-outputs`to regenerate models
- rename the project via the VSCode command pallette and replace 'tech.quantumgray.qg_flutter_starter' and 'qg_flutter_starter' with whatever applicable
- https://fvm.app/docs/getting_started/configuration

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*Qg Flutter Starter works on iOS, Android, and Web._

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# install lcov if no already
$ brew install lcov

# Run tests
$ flutter test --coverage --test-randomize-ordering-seed random

# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/html/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:qg_flutter_starter/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization

---

template_app
🦄📱 very awesome template app covering every manageable and architectural aspects of a Flutter app
STEPS
ensure a Firebase project is linked to the app
uncomment # FIREBASE dependencies inside pubspec.yaml and lock all dependencies to static semantically stable version id's
search for files containing cloud_firestore dependencies
install fvm and run fvm flutter pub get
fetch the vscode utils and hooks repos submodules and reference the hooks it in your git config git sumbodule update --init --recursive .then git config core.hooksPath hooks .then chmod ug+x hooks/*
re-generate localizations
    fvm flutter pub run build_runner build --delete-conflicting-outputs
customize

LifecycleManager
localizations inside l10n folder
theme
setup function + error tracing function in main
go through all 'TODO's' and ensure ApplicationId, BundleId and displayable app names are adapted

Android
Open AndroidManifest.xml (located at android/app/src/main)

<application
    android:label="App Name" ...>
iOS
Open info.plist (located at ios/Runner)

<key>CFBundleName</key>
<string>App Name</string>
Don't forget to run flutter clean

GUIDE
reduce boilerplate code by using extension methods defined in lib/core/extensions`
exceptions extend CustomException
platform aware dependencies and API implementations are handled via PlatformStub in lib/core/platform
asset paths are statically exposed via Assetsclass
other constants are exposed via Constants or ConstantsUi
follow lint rules
architecture
services provide an abstraction to interacting with I/O and external app API's that are wrapped in repositories
superblocs selectively call service API's for domain specific functionality
blocs depend on superblocs functionality and compose their design according to the actual app logic for specific screens (blocs are watching superblocs as a dependency and are declared as autodispose (and family for dynamic input))
UI components access or depend on blocs and but do not implement anything themselves
providers have a 'p' at their beginning to enable lint to list all available providers
generate protos into lib/gen via protoc --dart_out=./lib/gen ./protos/something.proto
protoc --swift_out=./ios/Classes ./protos/person.proto for iOS
https://www.freecodecamp.org/news/flutter-platform-channels-with-protobuf-e895e533dfb7/
