# Winamp Flutter test submission

A short demo video of the app can be found [here](https://drive.google.com/file/d/16K0IzixFhxfrMgwn5aW_RxIX1CoV8aHy/view?usp=sharing)

## Features

- **Friendly User Interface**
  - Redesigned for ease of use and better navigation.

- **Player**
  - Supports multiple options with efficient state management.

- **Working winamp-inspired Equalizer**
  - Classic equalizer UI based on Winamp ios app.

- **Drag and Drop Audio**
  - Easily add songs by dragging and dropping files into the app and also by selecting file in a folder.

- **Organized Library**
  - Automatically sorts songs by albums and artists using audio metadata.

- **Custom Themes**
  - Changing themes managed by state management.
  - Create, save and delete your own custom themes.

- **Window Size Control**
  - Minimum and maximum window sizes for optimal display.

- **Database Management**
  - Quickly delete all songs from the database with a single button.

- **Code Organization**
  - Structured file system for better code maintainability and scalability.

## My Configuration

- **Flutter**
  - Version: **3.24.4**
  - Channel: **stable**

- **Operating System**
  - **macOS 15.1** (Darwin arm64)

- **Android Development**
  - Android SDK version **34.0.0**
  - Android toolchain installed and configured

- **iOS/macOS Development**
  - Xcode version **16.1**

- **Locale**
  - **en-BE**

## Usage

- **Add Music**
  - Drag and drop your audio files into the app to add them to your library.

- **Browse Library**
  - View your songs organized by albums and artists.

- **Customize Themes**
  - Go to settings to select, save, or delete custom themes.

- **Manage Playback**
  - Use the player controls to play, pause, forward, backward, next, previous, shuffle, slider jump to.

- **Clear Library**
  - Click the "Delete All Songs" button to remove all songs from the database.

## Code Organization

To maintain a clean and scalable codebase, the project is organized into the following structure:

- **lib/**
  - **main.dart**: Entry point of the application.
  - **app_widget.dart**: Root widget of the application.
  - **database/**: Database setup file, with .g.dart file for database generation.
  - **models/**: Data models for songs, albums, artists, etc.
  - **pages/**: pages of the application when navigating.
  - **screens/**: standalone screens (scaffolds).
  - **widgets/**: Reusable components and UI elements.
  - **services/**: inteded for native api communication(not made).

## Database Migrations

Two migrations have been performed to enhance the database schema:

1. **Migration 1**
   - **Added Columns:** `[albumArt]`
   - **Purpose:** `[to display album art(image)]`

2. **Migration 2**
   - **Added Columns:** `[albumTitle]`
   - **Purpose:** `[to display album title]`



## Added Libraries

The project utilizes the following libraries to implement its features:

- **Provider**: For state management.
- **cupertino_icons**: For iOS icons.
- **desktop_window**: For window management.
- **desktop_drop**: For drag and drop functionality.
- **path**: For file path manipulation.
- **uuid**: For generating unique IDs.

```
flutter pub add provider cupertino_icons desktop_window desktop_drop path uuid
```





## Future Improvements

- **Architecture Enhancements**
  - Adopt **Clean Architecture**, **MVVM**, or **Vertical Slice** for better separation of concerns and maintainability.

- **Advanced State Management**
  - Implement **BLoC** for more robust and scalable state handling, especially for a feature-rich media player.

- **Server Integration**
  - Connect to a server to fetch and download files from various sources, enabling a more dynamic library.

- **Native API Integration**
  - Utilize **MethodChannel** to access native APIs for enhanced performance and capabilities.
  like Airplay...etc.

- **Enhanced Theming**
  - Leverage the **ThemeData** class to create more dynamic and flexible theming options.

- **Animations and UI Enhancements**
  - Incorporate smooth animations and a super clean UI to improve user experience.

<br><br><br><br><br><br><br><br><br>
_______________________________________________________________________________________________________________________


# Winamp Flutter test
## Setup

You should have Flutter and XCode tools installed in order to compile this on macOS
Make sure you also have Cocoapod install. You can install it via
```
sudo gem install cocoapods
```
You can also make sure your Flutter install is OK with 
```
flutter doctor
```

Prepare a folder structure containing audio files
(Test albums can be [downloaded here](https://drive.google.com/drive/folders/1MW6fPINhMM_m9NsqszBefsUoaQXXznnL?usp=sharing))

Create a new project targeting at least macOS/Windows

Run the following command in your project to install dependencies :
```
flutter pub add path_provider mime flutter_media_metadata drift drift_flutter dev:drift_dev dev:build_runner file_picker flutter_colorpicker media_kit media_kit_libs_audio shared_preferences
```
Copy these files in the ```lib``` folder of your project
```
  - main.dart
  - TrackModel.dart
  - database.dart
```
Run the following command; it generates the ```database.g.dart``` file, and needs to be re-run if you modify the database-related code:
```
dart run build_runner build
```

To compile for macos, you might need to first run:
```
pod repo update
```

To start the app, run:
```
flutter run -d macos
```

## Player
This application is a very basic audio player. You can choose a folder to browse for audio, which will import the tracks in a local db and display it in the app.
There is also a basic theme editor, as well as an hardcoded equalizer.


- Improve this application by creating a UI for the equalizer. This UI, either part of the current page or in a new page, should allow the user to manually change each band of the equalizer with a vertical slider. You can base your design on the original winamp equalizer if you want.
- What are some of the problems of the current app, and what would be ways to improve it?


You can send us back your test the same way we send it to you : if you added files, dependencies, or anything else, update the README.md accordingly so we can compile it on our side.

PS : if you want to reset the state of the app, you can delete the content of ```~/Library/Containers/YOUR_PACKAGE_NAME``` from your computer.