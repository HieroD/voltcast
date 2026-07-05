import numpy as np
import joblib
from flask import Flask, request, jsonify
from flask_cors import CORS
from tensorflow.keras.models import load_model

app = Flask(__name__)
CORS(app)

model    = load_model('model_export/best_model.keras')
scaler   = joblib.load('model_export/scaler.pkl')
metadata = joblib.load('model_export/metadata.pkl')
WINDOW   = metadata['window_size']  # 30

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    past_days = data.get('past_days')

    if not past_days or len(past_days) != WINDOW:
        return jsonify({'error': f'Need exactly {WINDOW} days of data'}), 400

    try:
        arr = np.array(past_days, dtype=np.float32).reshape(-1, 1)
        arr_scaled = scaler.transform(arr)
        X = arr_scaled.reshape(1, WINDOW, 1)
        pred_s = model.predict(X, verbose=0)
        pred_mw = float(scaler.inverse_transform(pred_s)[0][0])
    except Exception as e:
        return jsonify({'error': 'Prediction failed', 'detail': str(e)}), 500

    return jsonify({
        'predicted_mw': round(pred_mw, 2),
        'model': metadata.get('best_model_name', 'GRU'),
    })


@app.route('/model-info', methods=['GET'])
def model_info():
    """Return model metadata from training."""
    metrics = metadata.get('metrics', {})
    return jsonify({
        'loaded_model': metadata.get('best_model_name', 'N/A'),
        'window_size':  metadata.get('window_size', WINDOW),
        'model': {
            'name': metrics.get('Model', 'N/A'),
            'mse':  metrics.get('MSE', 0),
            'rmse': metrics.get('RMSE', 0),
            'mae':  metrics.get('MAE', 0),
            'r2':   metrics.get('R²', 0),
            'mape': metrics.get('MAPE (%)', 0),
        },
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
