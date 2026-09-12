# MediKiosk — Quick Execution & Run Guide

**Project**: MediKiosk — Patient Case-Taking Software  
**Problem Statement**: SIH26047 — Ministry of AYUSH / AIIA  
**Root Workspace**: `C:\Users\thouf\arya\MediKiosk-System\backend\back-arya`

---

## 1. Prerequisites

- **Flutter SDK**: Installed at `C:\Users\thouf\develop\flutter\bin`
- **Android Studio / Emulator**: SDK set up with Android API 30+
- **Python**: Python 3.10+ (System environment dependent)

---

## 2. Running the FastAPI Backend Service

Open a PowerShell terminal in the backend directory:

```powershell
cd C:\Users\thouf\arya\MediKiosk-System\backend\back-arya

# Initialize virtual environment (if python is available)
python -m venv .venv
.\.venv\Scripts\Activate.ps1

# Install requirements
pip install -r requirements.txt

# Launch FastAPI app on all host interfaces
python run.py
```

- **Swagger Documentation**: `http://localhost:8000/docs`
- **System Health Check**: `http://localhost:8000/api/health`

---

## 3. Running the Flutter Kiosk Application

Open a second PowerShell terminal in the `mobile` directory:

```powershell
cd C:\Users\thouf\arya\MediKiosk-System\backend\back-arya\mobile

# Get Flutter dependencies
C:\Users\thouf\develop\flutter\bin\flutter.bat pub get

# Analyze Dart code (0 errors)
C:\Users\thouf\develop\flutter\bin\flutter.bat analyze --no-fatal-infos

# Run unit and widget tests
C:\Users\thouf\develop\flutter\bin\flutter.bat test

# Run on Android Emulator (Defaults to http://10.0.2.2:8000)
C:\Users\thouf\develop\flutter\bin\flutter.bat run
```

### Running on Physical Android Device (LAN Connection)

1. Find your laptop's IPv4 address:
   ```powershell
   ipconfig
   ```
   *(Example: `192.168.1.105`)*

2. Pass the custom `API_BASE_URL` to Flutter:
   ```powershell
   C:\Users\thouf\develop\flutter\bin\flutter.bat run --dart-define=API_BASE_URL=http://192.168.1.105:8000
   ```

---

## 4. Offline Mock / Judge Demonstration Mode

If the backend server is not running during a demo, turn on Mock Mode:

1. Open [`mobile/lib/core/network/repositories.dart`](file:///C:/Users/thouf/arya/MediKiosk-System/backend/back-arya/mobile/lib/core/network/repositories.dart#L18)
2. Toggle `kMockMode`:
   ```dart
   const bool kMockMode = true; // Offline judge demo mode
   ```
3. In Mock Mode:
   - All 27 patient screens navigate seamlessly with pre-configured mock payloads.
   - **Doctor Demo PIN**: `1234`

---

## 5. Building the Production Release APK

To create the final standalone Android release APK:

```powershell
cd C:\Users\thouf\arya\MediKiosk-System\backend\back-arya\mobile
C:\Users\thouf\develop\flutter\bin\flutter.bat build apk --release
```

- **Output File**: `mobile/build/app/outputs/flutter-apk/app-release.apk`
