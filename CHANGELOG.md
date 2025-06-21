# 📄 Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),  
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]
- Offline mode exploration for self-contained deployments
- UI enhancements for translation output section
- OCR accuracy improvements via preprocessing pipeline

---

## [v1.2.0] - 2025-06-20
### Added
- 🎯 Firebase Authentication (Google login) + Guest mode
- 📁 Firestore integration to save extracted text per user
- 🌐 Language selectors for OCR and translation
- 🧠 Translations using Deep Translate API

### Changed
- 🔁 Reorganized 2_uploadextract.dart with full language support
- 🛠 Updated error handling for both OCR and translation endpoints
- 💡 Improved UI responsiveness and theme polish

---

## [v1.1.0] - 2025-06-15
### Added
- 🧾 Translation API route in FastAPI backend
- 🌍 Support for 16 Indic languages
- 🐍 `requirements.txt` added for backend setup

### Fixed
- 📦 Dependency issues on fresh backend install
- 🔐 Secrets masking in frontend logs

---

## [v1.0.0] - 2025-06-10
### Added
- 🚀 Full OCR support using Tesseract (PDF + Image)
- 📤 Document upload via Flutter frontend
- 🧾 Extracted text viewer + copy/download
- 🔄 CORS setup and API endpoints in FastAPI

---

## [Initial] - 2025-06-01
- Project scaffolded with basic OCR working end-to-end

---

**Maintained by the BITS-PS1-2025 OCR Digitization Team**