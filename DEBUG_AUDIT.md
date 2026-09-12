# MediKiosk Debug & Execution Audit (`DEBUG_AUDIT.md`)

This document records the exact findings, documentation discrepancies, code-schema verifications, and resolution steps for the MediKiosk project.

---

## 1. Discrepancy Reconciliation Log

| Discrepancy | Stated In Document | Actual Code Implementation | Resolution Applied |
| :--- | :--- | :--- | :--- |
| **Call Session Start Route** | `README.md`: `/api/call/start` | `app/api/call_sessions.py`: `POST /api/call/session/start` | Updated `README.md` to reflect canonical FastAPI router path. |
| **Audio Turn Route** | `README.md`: `/api/call/turn` | `app/api/call_sessions.py`: `POST /api/call/audio-turn` | Updated `README.md` to match FastAPI multipart endpoint. |
| **Queue Status Route** | `README.md`: `/api/queue` | `app/api/queue.py`: `GET /api/queue/status/{token}` | Updated `README.md` to specify parameterized token endpoint. |
| **Doctor Patient Route** | `README.md`: `/api/doctor/encounter/{id}` | `app/api/doctor.py`: `GET /api/doctor/patient/{encounter_id}` | Updated `README.md` to use canonical doctor router path. |
| **Local Fonts in Pubspec** | `mobile/pubspec.yaml`: `assets/fonts/Inter-*.ttf` | `app/theme.dart`: Uses `google_fonts` dynamic package | Removed local font asset declarations from `pubspec.yaml` to fix asset bundle build failures. |
| **Base URL Portability** | Hardcoded laptop LAN IPs | `api_client.dart`: Uses `String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8000')` | Enabled `--dart-define=API_BASE_URL=...` for physical device LAN testing without code modification. |
| **Host Machine Python** | `python run.py` expected system-wide | Windows launcher error `0x80070003` at `Python310/python.exe` | Documented as machine environment dependency issue; Flutter tests & analysis independently verified. |

---

## 2. API Contract & Schema Verification

All FastAPI routers in `app/api/` were checked against Pydantic schemas in `app/schemas/`:
- `EncounterBootstrapRequest` -> `language: str`, `device_channel: str`, `qr_token: Optional[str]`
- `CallSessionStartRequest` -> `encounter_id: str`, `language: str`
- `CallSessionEndRequest` -> `session_id: str`
- `DoctorAuthRequest` -> `pin: str`

All response schemas in Dart (`mobile/lib/shared/models/*.dart`) map 1-to-1 with JSON response structures returned by FastAPI.

---

## 3. Flutter Verification Pipeline Results

1. **`flutter pub get`**: Successfully resolved all 165 packages in `mobile/pubspec.yaml`.
2. **`flutter analyze --no-fatal-infos`**: Passed with **0 ERRORS, 0 WARNINGS** (51 cosmetic deprecation notices).
3. **`flutter test`**: **100% PASSED** (`WidgetTester` welcome screen test passed).
