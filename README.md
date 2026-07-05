# VoltCast ⚡ City Demand Forecasting

**VoltCast** is a city-scale electricity demand forecasting application (Mobile GUI Deep Learning). This repo covers the Flask API backend, Flutter frontend, and model integration.

---

## Dataset

Source: **[AEP Hourly Energy Consumption (Kaggle)](https://www.kaggle.com/datasets/robikscube/hourly-energy-consumption)**

### Metadata

| Field           | Description                                       |
|-----------------|---------------------------------------------------|
| Datetime        | Timestamp of the recorded consumption             |
| Konsumsi_MW | Hourly electricity consumption in MW (target)     |

### Training Statistics

| Metric    | Value               |
|-----------|---------------------|
| Best Model | GRU                |
| Window Size | 30 days           |
| Data Range | 11,078 - 20,898 MW |
| RMSE      | ~693 MW             |
| MAE       | ~534 MW             |
| R²        | ~0.85               |
| MAPE      | ~3.6%               |

---

## Aim

Build a predictive model to forecast **next-day city electricity demand (MW)** based on the past 30 days of historical consumption data, enabling grid operators and utility planners to anticipate load.

---

## Tech Stack

| Layer            | Technology                        |
|------------------|-----------------------------------|
| Frontend         | Flutter (Dart)                    |
| Backend          | Flask (Python)                    |
| ML Framework     | TensorFlow / Keras                |
| Preprocessing    | MinMaxScaler (scikit-learn)       |
| Dataset          | AEP Hourly Energy Consumption     |

---

## Folder Structure

```
voltcast/
├─ backend/
│  ├─ app.py                    # Flask API (/predict, /model-info)
│  ├─ requirements.txt          # Python dependencies
│  └─ model_export/             # Trained model artifacts
│     ├─ best_model.keras       # GRU model
│     ├─ scaler.pkl             # MinMaxScaler
│     └─ metadata.pkl           # Training metadata
│
└─ frontend/
   ├─ pubspec.yaml
   └─ lib/
      ├─ main.dart                          # App entry + bottom nav
      ├─ theme/
      │  └─ app_theme.dart                  # Colors & theme
      ├─ services/
      │  └─ prediction_service.dart         # HTTP client
      ├─ screens/
      │  ├─ input_screen.dart               # 30-day MW input
      │  ├─ result_screen.dart              # Forecast + chart
      │  └─ about_screen.dart               # App info + model metadata
      └─ widgets/
         └─ custom_input.dart               # Reusable MW field
```

---

## API Contract

### Request Body

```json
{
  "past_days": [15000, 15200, 14800, 15500, 16000, 15800, 15100, 14900, 15300, 15700, 16200, 15900, 14700, 15400, 15600, 15000, 16100, 16300, 15800, 15200, 14900, 15500, 15700, 16000, 15300, 15100, 15900, 16200, 15400, 14800]
}
```

> `past_days`  Array of exactly **30** float values in **MW**. 

### Success Response

```json
{
  "predicted_mw": 15934.56,
  "model": "GRU"
}
```

The model name is returned alongside the prediction so the frontend doesn't need a separate round-trip.

### Error Response

```json
{
  "error": "Need exactly 30 days of data"
}
```

Returns HTTP 400 for validation errors, HTTP 500 for inference failures.

### Additional Endpoint

**`GET /model-info`** Returns model metadata (architecture, training metrics).

```json
{
  "loaded_model": "GRU",
  "window_size": 30,
  "model": {
    "name": "GRU",
    "mse": 480323.44,
    "rmse": 693.05,
    "mae": 534.51,
    "r2": 0.8489,
    "mape": 3.62
  }
}
```

---

## Installation

**Prerequisite:** Python **>= 3.10**, Flutter **>= 3.x**

### Backend

```bash
cd backend

# Optional: create virtual environment
python3 -m venv venv
source venv/bin/activate   # Linux/macOS
# .\venv\Scripts\Activate.ps1  # Windows PowerShell

# Install dependencies
pip install -r requirements.txt

# Place model artifacts in backend/model_export/
# (best_model.keras, scaler.pkl, metadata.pkl)
```

### Frontend

```bash
cd frontend

# Install Flutter dependencies
flutter pub get
```

---

## Running the Backend

```bash
cd backend
python app.py
```

Server starts on **`http://127.0.0.1:5000`**.

**Output:**

```
* Running on http://127.0.0.1:5000
* Running on http://<LAN-IP>:5000
```

**Quick test:**

```bash
curl http://localhost:5000/model-info
curl -X POST http://localhost:5000/predict \
  -H "Content-Type: application/json" \
  -d '{"past_days": [15000, 15200, 14800, 15500, 16000, 15800, 15100, 14900, 15300, 15700, 16200, 15900, 14700, 15400, 15600, 15000, 16100, 16300, 15800, 15200, 14900, 15500, 15700, 16000, 15300, 15100, 15900, 16200, 15400, 14800]}'
```

---

## Running the Frontend

```bash
cd frontend

# Web browser
flutter run -d chrome
# or
flutter run -d web-server --web-port 8080
```

Open **`http://localhost:8080`** (or the port shown in the terminal).

---

## Connecting Frontend to Backend

In `frontend/lib/services/prediction_service.dart`:

```dart
// Same machine (web): 
final String apiUrl = "http://localhost:5000";

// Android emulator:
// final String apiUrl = "http://10.0.2.2:5000";

// Physical device on same WiFi (replace with your laptop's LAN IP):
// final String apiUrl = "http://192.168.1.x:5000";
```

After changing the URL, do a **hot restart** (`r` in the Flutter terminal, not `R` for hot reload).

---

## Team

**Kelompok 3**  
S1 Sistem Informasi  
UAS Praktikum Machine Learning 2026
