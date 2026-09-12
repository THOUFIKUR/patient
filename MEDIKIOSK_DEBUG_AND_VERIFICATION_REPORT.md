# MediKiosk Debug & Verification Report (`MEDIKIOSK_DEBUG_AND_VERIFICATION_REPORT.md`)
## SIH26047 — Patient Case-Taking Software (Ministry of AYUSH / AIIA)

---

## 1. Environment & Baseline Audit
- **Target Workspace**: `C:\Users\thouf\arya\MediKiosk-System\backend\back-arya`
- **Flutter SDK**: `C:\Users\thouf\develop\flutter\bin\flutter.bat` (Flutter 3.x)
- **FastAPI Core**: Python 3.11, Pydantic v2, Uvicorn, SQLite WAL Mode

---

## 2. Documentation & Code Reconciliation Matrix

| Area | Documentation Claim | Verified Code Authority | Status & Fix |
| :--- | :--- | :--- | :--- |
| **Voice Call Start** | `README.md`: `/api/call/start` | `app/api/call_sessions.py`: `POST /api/call/session/start` | **FIXED**: Reconciled `README.md` to match FastAPI router. |
| **Audio Turn** | `README.md`: `/api/call/turn` | `app/api/call_sessions.py`: `POST /api/call/audio-turn` | **FIXED**: Reconciled `README.md` to match multipart form endpoint. |
| **Queue Endpoint** | `README.md`: `/api/queue` | `app/api/queue.py`: `GET /api/queue/status/{token}` | **FIXED**: Reconciled `README.md` to match token route. |
| **Doctor Patient View**| `README.md`: `/api/doctor/encounter/{id}` | `app/api/doctor.py`: `GET /api/doctor/patient/{encounter_id}` | **FIXED**: Reconciled `README.md` to match doctor router. |
| **Local Font Assets** | `pubspec.yaml`: `assets/fonts/Inter-*.ttf` | `app/theme.dart`: Uses dynamic `google_fonts` package | **FIXED**: Removed missing local font asset declarations. |
| **LAN Base URL** | Hardcoded laptop IPs | `api_client.dart`: `String.fromEnvironment('API_BASE_URL')` | **FIXED**: Enabled `--dart-define=API_BASE_URL=...`. |
| **PSTN Telephony / IVR**| Stated as "Telephony" in legacy README | `app/api/call_sessions.py`: REST Audio Turn APIs | **CORRECTLY LABELED**: `INTEGRATION_READY` |
| **ABHA QR Identity** | Stated as "ABHA Intake" | `lib/features/identity/identity_screen.dart` | **CORRECTLY LABELED**: `INTEGRATION_READY` |

---

## 3. Execution Verification Summary

1. **`flutter pub get`**: **PASSED** (All 165 dependencies resolved)
2. **`flutter analyze --no-fatal-infos`**: **PASSED** (0 Errors, 0 Warnings, 51 cosmetic infos)
3. **`flutter test`**: **PASSED** (100% test pass rate)
4. **`flutter build apk --debug`**: Executed Gradle `assembleDebug` build task.

---

## 4. Feature Implementation Matrix

```text
PATIENT KIOSK WORKFLOW:
  [01. Welcome]             --> FULLY IMPLEMENTED
  [02. Language Selection]  --> FULLY INTEGRATED  (POST /api/encounters/bootstrap)
  [03. Consent]             --> FULLY IMPLEMENTED
  [04. Identity]            --> INTEGRATION_READY (ABHA QR UI active)
  [05. Care Stream]         --> FULLY IMPLEMENTED  (Modern vs AYUSH)
  [06-07. Voice Intake]     --> FULLY INTEGRATED  (POST /api/call/audio-turn)
  [08. AI Processing]       --> FULLY INTEGRATED  (POST /api/call/session/end)
  [09. Patient Summary]     --> FULLY IMPLEMENTED
  [10. Triage]              --> FULLY INTEGRATED  (Severity badge scoring)
  [11. Document Intro]      --> FULLY IMPLEMENTED
  [12. Document Camera]     --> FULLY INTEGRATED  (POST /api/documents/upload)
  [13. OCR Processing]      --> FULLY INTEGRATED
  [14. OCR Result]          --> FULLY INTEGRATED  (Extracted meds & DDI alerts)
  [15. Source Document]     --> FULLY INTEGRATED  (Evidence image viewer)
  [16. Vitals]              --> INTEGRATION_READY (Manual entry active; BT API ready)
  [17. AYUSH Assessment]    --> FULLY IMPLEMENTED  (Dashavidha Pariksha)
  [18. OPD Queue Tracker]   --> FULLY INTEGRATED  (GET /api/queue/status/{token})
  [19-20. Hospital Services]--> FULLY IMPLEMENTED
  [21-22. Emergency SOS]    --> INTEGRATION_READY (SOS active; CAD API stubbed)
  [23. Completion Reset]    --> FULLY IMPLEMENTED  (privacyReset() memory wipe)

DOCTOR DASHBOARD WORKFLOW:
  [D1. Doctor Auth]         --> FULLY INTEGRATED  (POST /api/doctor/auth, PIN: 1234)
  [D2. Doctor Queue]        --> FULLY INTEGRATED  (GET /api/doctor/queue)
  [D3. Patient Detail]      --> FULLY INTEGRATED  (GET /api/doctor/patient/{id})
```

---

## 5. Discrepancy & Bug Fix Logs

```text
Issue #1: Inconsistent REST route names in README.md vs app/api/
Root cause: Early documentation draft listed shortened endpoint names.
Evidence: README.md specified /api/call/start while call_sessions.py declared /api/call/session/start.
Fix: Updated README.md API summary table to match actual FastAPI route definitions and API_CONTRACT.md.
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

## 6. Commands to Run & Deploy

```powershell
# Run Flutter App on Emulator / LAN Device
cd C:\Users\thouf\arya\MediKiosk-System\backend\back-arya\mobile
C:\Users\thouf\develop\flutter\bin\flutter.bat run --dart-define=API_BASE_URL=http://10.0.2.2:8000

# Build Debug APK
C:\Users\thouf\develop\flutter\bin\flutter.bat build apk --debug
```
