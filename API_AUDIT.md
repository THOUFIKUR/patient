# MediKiosk API Audit (`API_AUDIT.md`)

Detailed audit of all FastAPI REST endpoints, Pydantic request/response schemas, authentication requirements, and Flutter consumer implementations in `mobile/lib/core/network/repositories.dart`.

---

## Endpoint Contract Table

| Feature | Method | Endpoint | Request Model | Response Model | Auth | Flutter Consumer | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Encounter Bootstrap** | `POST` | `/api/encounters/bootstrap` | `EncounterBootstrapRequest` | `EncounterBootstrapResponse` | None | `EncounterRepository.bootstrap()` | `INTEGRATED` |
| **Encounter Detail** | `GET` | `/api/encounters/{id}` | N/A | `EncounterSummary` | None | `EncounterRepository.getEncounter()` | `INTEGRATED` |
| **Encounter Status** | `PATCH` | `/api/encounters/{id}/status` | `EncounterStatusUpdate` | `dict` | None | Direct API call | `INTEGRATED` |
| **Voice Session Start** | `POST` | `/api/call/session/start` | `CallSessionStartRequest` | `CallSessionStartResponse` | None | `IntakeRepository.startSession()` | `INTEGRATED` |
| **Voice Audio Turn** | `POST` | `/api/call/audio-turn` | Form: `session_id`, `audio_file` | `AudioTurnResponse` | None | `IntakeRepository.processAudioTurn()` | `INTEGRATED` |
| **Voice Session End** | `POST` | `/api/call/session/end` | `CallSessionEndRequest` | `CallSessionEndResponse` | None | `IntakeRepository.endSession()` | `INTEGRATED` |
| **Document OCR Upload** | `POST` | `/api/documents/upload` | Form: `encounter_id`, `document` | `DocumentUploadResponse` | None | `DocumentRepository.uploadDocument()` | `INTEGRATED` |
| **Queue Token Status** | `GET` | `/api/queue/status/{token}` | N/A | `QueueStatusResponse` | None | `QueueRepository.getStatus()` | `INTEGRATED` |
| **Queue Overview** | `GET` | `/api/queue/all` | N/A | `dict` | None | Direct API call | `INTEGRATED` |
| **Doctor Auth** | `POST` | `/api/doctor/auth` | `DoctorAuthRequest` | `DoctorAuthResponse` | PIN (`1234`) | `DoctorRepository.authenticate()` | `INTEGRATED` |
| **Doctor Queue** | `GET` | `/api/doctor/queue` | N/A | `DoctorQueueResponse` | PIN required | `DoctorRepository.getQueue()` | `INTEGRATED` |
| **Doctor Patient View** | `GET` | `/api/doctor/patient/{id}` | N/A | `PatientDetailView` | PIN required | `DoctorRepository.getPatientDetail()` | `INTEGRATED` |
| **Doctor Call Next** | `POST` | `/api/doctor/patient/{id}/call-next` | N/A | `dict` | PIN required | `DoctorRepository.callNextPatient()` | `INTEGRATED` |

---

## Data Schema Verification Matrix

### 1. `EncounterBootstrapResponse`
- `encounter_id`: String (UUID formatted, e.g., `enc-a1b2c3d4`)
- `patient_id`: String (UUID formatted, e.g., `pat-e5f6g7h8`)
- `token_number`: String (Human readable OPD token, e.g., `A-042`)
- `status`: String (`BOOTSTRAPPED`, `IN_PROGRESS`, `COMPLETED`)
- `supported_languages`: List of `LanguageOption` (`en`, `hi`, `ta`, `te`, `mr`)

### 2. `CallSessionStartResponse`
- `session_id`: String (`call-sess-12345678`)
- `status`: String (`CALL_ACTIVE`)
- `opening_text`: String (Localized opening prompt text)
- `opening_audio_base64`: Optional String (Base64 audio payload from TTS engine)

### 3. `DocumentUploadResponse`
- `document_id`: String (`doc-12345678`)
- `ocr_status`: String (`SUCCESS`, `LOW_CONFIDENCE`, `FAILED`)
- `extracted_medications`: List of `ExtractedMedication` (`name`, `dose`, `frequency`, `source_lines`, `confidence`)
- `flagged_interactions`: List of `DrugInteractionAlert`
- `highlighted_image_url`: Optional String (URL pointing to `/static/evidence/...-boxed.jpg`)
