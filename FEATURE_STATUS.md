# MediKiosk Feature Status Matrix (`FEATURE_STATUS.md`)

Comprehensive status breakdown of all 27 screens, backend engines, and external infrastructure integration boundaries for SIH26047.

---

## 1. Patient Kiosk Screens & Modules

| Screen / Feature | Route Path | Implementation Status | Notes / Integration Boundary |
| :--- | :--- | :--- | :--- |
| **01. Welcome** | `/` | `FULLY IMPLEMENTED` | High-contrast touch start screen |
| **02. Language Selection** | `/language` | `FULLY INTEGRATED` | 5 languages (EN, HI, TA, TE, MR) connected to `/api/encounters/bootstrap` |
| **03. Consent** | `/consent` | `FULLY IMPLEMENTED` | Data privacy terms & DPDP Act consent check |
| **04. Identity / Registration** | `/identity` | `INTEGRATION_READY` | ABHA QR / Mobile input UI active; official NDHM API key ready |
| **05. Care Stream** | `/care-stream` | `FULLY IMPLEMENTED` | Modern Medicine vs AYUSH Care pathway selection |
| **06-07. Voice Intake** | `/intake/voice` | `FULLY INTEGRATED` | Live mic capture & audio turn loop connected to `/api/call/audio-turn` |
| **08. AI Processing** | `/intake/ai-processing` | `FULLY INTEGRATED` | Fact extraction animation connected to `/api/call/session/end` |
| **09. Patient Summary** | `/summary` | `FULLY IMPLEMENTED` | Chief complaint & extracted symptom review card |
| **10. Triage** | `/triage` | `FULLY INTEGRATED` | Severity badge (RED / YELLOW / GREEN) & priority score display |
| **11. Document Intro** | `/documents` | `FULLY IMPLEMENTED` | Prescription scanning instructions |
| **12. Document Camera** | `/documents/camera` | `FULLY INTEGRATED` | Live camera view & image capture connected to `/api/documents/upload` |
| **13. OCR Processing** | `/documents/ocr-processing` | `FULLY INTEGRATED` | OCR extraction state |
| **14. OCR Result** | `/documents/ocr-result` | `FULLY INTEGRATED` | Extracted medications & DDI conflict warnings |
| **15. Source Document** | `/documents/source` | `FULLY INTEGRATED` | Prescriptions & evidence image viewer |
| **16. Vitals** | `/vitals` | `INTEGRATION_READY` | Manual entry active; Bluetooth medical hardware API ready |
| **17. AYUSH Assessment** | `/ayush` | `FULLY IMPLEMENTED` | Dashavidha Pariksha (Agni, Prakriti, Koshtha) intake UI |
| **18. OPD Queue Tracker** | `/queue` | `FULLY INTEGRATED` | Token polling connected to `/api/queue/status/{token}` |
| **19. Hospital Services** | `/hospital` | `FULLY IMPLEMENTED` | Hospital OPD services directory |
| **20. Hospital Map** | `/hospital/map` | `FULLY IMPLEMENTED` | Interactive wayfinding map |
| **21. Emergency SOS** | `/emergency` | `INTEGRATION_READY` | SOS trigger active; external CAD dispatch API stubbed |
| **22. Ambulance Status** | `/emergency/ambulance` | `INTEGRATION_READY` | Ambulance tracking UI active; CAD API stubbed |
| **23. Completion & Privacy Reset** | `/completion` | `FULLY IMPLEMENTED` | Session memory wipe (`privacyReset()`) on completion |

---

## 2. Doctor Dashboard Screens

| Module | Route Path | Implementation Status | Notes / Integration Boundary |
| :--- | :--- | :--- | :--- |
| **D1. Doctor Auth** | `/doctor` | `FULLY INTEGRATED` | 4-digit PIN authentication connected to `/api/doctor/auth` (PIN: `1234`) |
| **D2. Doctor Queue** | `/doctor/queue` | `FULLY INTEGRATED` | Triage cards with 30-word summaries connected to `/api/doctor/queue` |
| **D3. Patient Clinical View** | `/doctor/patient/:id` | `FULLY INTEGRATED` | 4-tab clinical card view connected to `/api/doctor/patient/{id}` |

---

## 3. Backend AI & Clinical Engines

| Engine | Location | Status | Implementation Details |
| :--- | :--- | :--- | :--- |
| **Drug Interaction Matrix** | `app/core/clinical/drug_safety.py` | `FULLY IMPLEMENTED` | 100% deterministic pairwise DDI checker |
| **Lab Range Checker** | `app/core/clinical/lab_checker.py` | `FULLY IMPLEMENTED` | Physiological interval evaluator (High/Low/Panic) |
| **Clinical Gap Detector** | `app/core/clinical/gap_detector.py` | `FULLY IMPLEMENTED` | Rule-based missing historical factor detector |
| **Speech ASR Floor** | `app/core/adapters/asr.py` | `INTEGRATED` | AI4Bharat IndicWhisper/Conformer + Sarvam AI Cloud |
| **Vision OCR Adapter** | `app/core/adapters/ocr.py` | `INTEGRATED` | RapidOCR ONNX + Gemini Flash Vision |
| **LLM Provider Router** | `app/core/adapters/llm.py` | `INTEGRATED` | Groq Llama 3.1 70B + Ollama Qwen 2.5 7B + Gemini Flash |
| **PSTN / IVR Gateway** | Architecture Spec | `INTEGRATION_READY` | REST audio session APIs active; PSTN gateway stubbed |
