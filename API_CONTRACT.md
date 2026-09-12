# MediKiosk API Contract Matrix

This matrix documents the actual FastAPI endpoints available in `app/api/` and their mapping to Flutter consumer repositories in `mobile/lib/core/network/repositories.dart`.

## Endpoint Alignment Matrix

| Method | Endpoint | Request Payload | Response Model | Flutter Repository Consumer | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `POST` | `/api/encounters/bootstrap` | `{ "language": "hi", "device_channel": "kiosk" }` | `EncounterBootstrapResponse` | `EncounterRepository.bootstrap()` | `INTEGRATED` |
| `GET` | `/api/encounters/{id}` | N/A | `EncounterSummary` | `EncounterRepository.getEncounter()` | `INTEGRATED` |
| `POST` | `/api/call/session/start` | `{ "encounter_id": "enc-123", "language": "hi" }` | `CallSessionStartResponse` | `IntakeRepository.startSession()` | `INTEGRATED` |
| `POST` | `/api/call/audio-turn` | Form-data: `session_id`, `audio_file` | `AudioTurnResponse` | `IntakeRepository.processAudioTurn()` | `INTEGRATED` |
| `POST` | `/api/call/session/end` | `{ "session_id": "call-sess-123" }` | `CallSessionEndResponse` | `IntakeRepository.endSession()` | `INTEGRATED` |
| `POST` | `/api/documents/upload` | Form-data: `encounter_id`, `document` | `DocumentUploadResponse` | `DocumentRepository.uploadDocument()` | `INTEGRATED` |
| `GET` | `/api/queue/status/{token}` | N/A | `QueueStatusResponse` | `QueueRepository.getStatus()` | `INTEGRATED` |
| `POST` | `/api/doctor/auth` | `{ "pin": "1234" }` | `DoctorAuthResponse` | `DoctorRepository.authenticate()` | `INTEGRATED` |
| `GET` | `/api/doctor/queue` | N/A | `DoctorQueueResponse` | `DoctorRepository.getQueue()` | `INTEGRATED` |
| `GET` | `/api/doctor/patient/{id}` | N/A | `PatientDetailView` | `DoctorRepository.getPatientDetail()` | `INTEGRATED` |
| `POST` | `/api/doctor/patient/{id}/call-next` | N/A | `{ "status": "CALLED" }` | `DoctorRepository.callNextPatient()` | `INTEGRATED` |

---

## Detailed Payload Schemas

### 1. Encounter Bootstrap (`POST /api/encounters/bootstrap`)
- **Request**:
  ```json
  {
    "language": "hi",
    "device_channel": "android_byod",
    "qr_token": null
  }
  ```
- **Response**:
  ```json
  {
    "encounter_id": "enc-a1b2c3d4",
    "patient_id": "pat-e5f6g7h8",
    "token_number": "A-042",
    "status": "BOOTSTRAPPED",
    "supported_languages": [
      {"code": "en", "label": "English"},
      {"code": "hi", "label": "हिन्दी"},
      {"code": "ta", "label": "தமிழ்"},
      {"code": "te", "label": "తెలుగు"},
      {"code": "mr", "label": "मराठी"}
    ]
  }
  ```

### 2. Call Session Start (`POST /api/call/session/start`)
- **Request**:
  ```json
  {
    "encounter_id": "enc-a1b2c3d4",
    "language": "hi"
  }
  ```
- **Response**:
  ```json
  {
    "session_id": "call-sess-12345678",
    "status": "CALL_ACTIVE",
    "opening_text": "नमस्ते! आपको आज क्या परेशानी है?",
    "opening_audio_base64": null
  }
  ```

### 3. Doctor Authentication (`POST /api/doctor/auth`)
- **Request**:
  ```json
  {
    "pin": "1234"
  }
  ```
- **Response**:
  ```json
  {
    "authenticated": true,
    "message": "Authentication successful"
  }
  ```
