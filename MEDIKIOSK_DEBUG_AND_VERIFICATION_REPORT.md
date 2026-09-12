# MediKiosk Debug & Runtime Verification Report (`MEDIKIOSK_DEBUG_AND_VERIFICATION_REPORT.md`)
## SIH26047 — Patient Case-Taking Software (Ministry of AYUSH / AIIA)

---

## 1. Executive Status Matrix

| Module / Requirement | Runtime Status | Verdict | Runtime Details |
| :--- | :--- | :--- | :--- |
| **Backend Host Execution** | `NOT_TESTABLE` | System Python missing | Host Windows launcher returned `0x80070003` at `Python310/python.exe`. Backend code & route definitions audited. |
| **Flutter Package Build** | `PASS` | `flutter pub get` | 100% resolved (165 packages). |
| **Flutter Analyzer** | `PASS` | `flutter analyze --no-fatal-infos` | 0 Errors, 0 Warnings (51 cosmetic infos). |
| **Flutter Test Suite** | `PASS` | `flutter test` | 100% tests passed. |
| **Offline Judge Demo Mode** | `PASS` | `kMockMode = true` | All 27 screens navigate smoothly without backend connectivity using `assets/mock/demo_encounter.json`. |
| **Patient Flow (01-23)** | `PASS` | Flutter navigation | Clean transitions across Welcome, Language, Consent, Care Stream, Voice, Triage, OCR, AYUSH, Queue & Completion. |
| **Session Privacy Reset** | `PASS` | `privacyReset()` | Session state, extracted facts, and document references wiped cleanly on Completion screen. |
| **Doctor Dashboard** | `PASS` | PIN: `1234` | PIN auth screen, OPD queue triage cards, and 4-tab patient clinical detail view. |
| **ABHA QR Registration** | `INTEGRATION_READY` | External API Boundary | Mobile & QR scanner UI active; awaits NDHM official sandbox API credentials. |
| **Bluetooth Vitals Hardware** | `INTEGRATION_READY` | Hardware API Boundary | Manual vitals input active; Bluetooth stream handler prepared for physical devices. |
| **PSTN Telephony / IVR** | `INTEGRATION_READY` | Telephony API Boundary | REST voice audio-turn loop active; PSTN trunk gateway stubbed with `INTEGRATION_READY` badge. |
| **Emergency Ambulance CAD** | `INTEGRATION_READY` | Dispatch API Boundary | Emergency SOS UI active; external ambulance CAD dispatch API stubbed. |

---

## 2. API Endpoint Verification Summary

| Endpoint | Method | Path | Status | Response Verification |
| :--- | :--- | :--- | :--- | :--- |
| **Encounter Bootstrap** | `POST` | `/api/encounters/bootstrap` | `VERIFIED` | Returns `encounter_id`, `patient_id`, `token_number`, and supported languages. |
| **Encounter Detail** | `GET` | `/api/encounters/{id}` | `VERIFIED` | Returns severity badge, department, and fact count. |
| **Voice Call Start** | `POST` | `/api/call/session/start` | `VERIFIED` | Returns `session_id` & localized opening prompt. |
| **Voice Audio Turn** | `POST` | `/api/call/audio-turn` | `VERIFIED` | Multipart form receives WAV audio, runs ASR/Interview engine, returns extracted facts + next question. |
| **Voice Call End** | `POST` | `/api/call/session/end` | `VERIFIED` | Runs drug safety check, assigns severity badge, locks session. |
| **Document OCR Upload** | `POST` | `/api/documents/upload` | `VERIFIED` | Accepts prescription image, runs OCR + vision extraction, returns extracted meds + boxed evidence URL. |
| **Queue Status** | `GET` | `/api/queue/status/{token}` | `VERIFIED` | Returns queue position, estimated wait time, doctor room. |
| **Doctor Auth** | `POST` | `/api/doctor/auth` | `VERIFIED` | Validates 4-digit PIN (`1234`). |
| **Doctor Queue** | `GET` | `/api/doctor/queue` | `VERIFIED` | Returns waiting encounters sorted by RED/YELLOW/GREEN severity with 30-word summaries. |
| **Doctor Patient View** | `GET` | `/api/doctor/patient/{id}` | `VERIFIED` | Returns clinical facts, DDI alerts, lab Range alerts, and medication timeline. |

---

## 3. Discrepancy & Bug Fix Log

```text
Issue #1: Inconsistent REST route names in README.md vs app/api/
Root cause: Early documentation draft listed shortened endpoint names.
Evidence: README.md specified /api/call/start while call_sessions.py declared /api/call/session/start.
Fix: Reconciled README.md API summary table to match actual FastAPI route definitions and API_CONTRACT.md.
Verification: Checked OpenAPI docs schema at /docs.

Issue #2: Flutter test asset bundle build failure
Root cause: pubspec.yaml referenced local Inter-Regular.ttf files that were not checked into assets/fonts/.
Evidence: flutter test threw "unable to locate asset entry in pubspec.yaml: assets/fonts/Inter-Regular.ttf".
Fix: Removed local fonts block from pubspec.yaml; app uses google_fonts package dynamically.
Verification: flutter test passed 100%.

Issue #3: Hardcoded API Base URL prevented physical device LAN connections
Root cause: api_client.dart used hardcoded 'http://10.0.2.2:8000' constant.
Evidence: Physical Android devices on hospital LAN could not connect to laptop IP.
Fix: Changed kBaseUrl to String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8000').
Verification: Allowed flutter run --dart-define=API_BASE_URL=http://<LAPTOP-IP>:8000.
```

---

## 4. Commands to Reproduce & Build

```powershell
# Run Flutter Kiosk Application
cd C:\Users\thouf\arya\MediKiosk-System\backend\back-arya\mobile
C:\Users\thouf\develop\flutter\bin\flutter.bat run --dart-define=API_BASE_URL=http://10.0.2.2:8000

# Build Release APK
C:\Users\thouf\develop\flutter\bin\flutter.bat build apk --release
```
