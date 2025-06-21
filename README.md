# 📱 OCR Digitization Flutter App

This Flutter app allows users to upload documents (images/PDFs), perform OCR using a FastAPI backend with Tesseract, and translate the extracted text into multiple Indic and international languages.

---

## 🚀 Features

- 📤 Upload image/PDF from device
- 🧠 OCR extraction using Tesseract
- 🌍 Translation using Deep Translate API
- 🔤 Supports 16 Indic + 6 international languages
- 🧾 Download, copy, or save text
- 🔐 Firebase Google Authentication + Guest Mode
- ☁️ Firestore integration to save extracted documents

---

## 🛠️ Prerequisites

- Flutter SDK (>=3.0)
- Android Studio or VS Code with Flutter setup
- Firebase project with Authentication and Firestore enabled
- FastAPI backend server running with OCR and translation support

---

## 🔧 Setup Instructions

### 1. Clone this repo

```bash
git clone https://code.swecha.org/BITS-PS1-2025/ocr-digitization-final.git
cd ocr-digitization-final
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Update IP in `2_uploadextract.dart`

```dart
final apiUrl = 'http://<your_ip>:8000/ocr';
final apiUrl = 'http://<your_ip>:8000/translate';
```

### 4. Setup Firebase

- Add your `google-services.json` (Android) or `firebase_options.dart` (FlutterFire CLI)
- Enable Google Sign-In & Firestore in Firebase Console

---

## ▶️ Run App

```bash
flutter run
```

---

## 🧪 Test Backend

Run this in your backend directory:

```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

Ensure your system has Tesseract installed and `.traineddata` files for required languages.

---

## 📁 Directory Structure

```
lib/
 ├── main.dart
 ├── 2_uploadextract.dart     # Main OCR + Translation screen
 ├── profile.dart             # Saved Docs view
 ├── settings.dart
 ├── help.dart
 └── auth/                    # Firebase auth logic
```

---

## 🧠 Supported Languages

OCR (Tesseract) codes: `eng`, `hin`, `tel`, `tam`, `kan`, `mal`, `ben`, `guj`, etc.  
Translation (ISO 639-1) codes: `en`, `hi`, `te`, `ta`, `kn`, `ml`, etc.

---

## 📝 License

MIT License © 2025 OCR Digitization Team