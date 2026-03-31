# Student Local Database App

A Flutter application developed for **Laboratory Activity 5** that demonstrates local data persistence and database management. 

## 📱 About The App

This application manages student data using a local SQLite database. It showcases complete CRUD (Create, Read, Update, Delete) capabilities alongside user session management, serving as a comprehensive example of local storage in a Flutter environment.

## ✨ Features

- **SQLite Database Integration:** Uses `sqflite` to store and securely manage student records locally on the device.
- **Full CRUD Operations:**
  - **Create:** Insert new student records into the database.
  - **Read:** Retrieve and display a dynamic list of all saved students.
  - **Update:** Modify existing student information.
  - **Delete:** Remove specific student records from the database.
- **Login Persistence:** Utilizes `shared_preferences` to remember the user's login state across app restarts, ensuring they don't have to log in repeatedly.

## 🛠️ Technology Stack

- [**Flutter & Dart**](https://flutter.dev/) - UI Framework and Language
- [**sqflite**](https://pub.dev/packages/sqflite) - SQLite plugin for Flutter
- [**shared_preferences**](https://pub.dev/packages/shared_preferences) - Persistent storage for simple data like session states

---
*Created for Setenta Laboratory Activity 5*
