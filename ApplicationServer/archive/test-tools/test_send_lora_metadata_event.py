import os
import json
import base64
import struct
import time
import paho.mqtt.client as mqtt


MQTT_BROKER = os.environ.get("MQTT_BROKER", "mosquitto")
MQTT_PORT = int(os.environ.get("MQTT_PORT", "8883"))
MQTT_CA_CERT_PATH = os.environ.get("MQTT_CA_CERT_PATH", "/certs/ca.pem")

APPLICATION_ID = os.environ.get("TEST_APPLICATION_ID", "1")
DEV_EUI = os.environ.get("TEST_DEV_EUI", "ac1f09fffe1acbd5")
GATEWAY_ID = os.environ.get("TEST_GATEWAY_ID", "0016c001f1237a90")

TOPIC = f"application/{APPLICATION_ID}/device/{DEV_EUI}/event/up"


def build_test_payload():
    now = int(time.time())
    raw = struct.pack(
        ">Lhhhh",
        now,
        int(21.50 * 100),
        int(24.50 * 100),
        int(44.50 * 100),
        int(46.50 * 100),
    )
    return base64.b64encode(raw).decode("utf-8")


event = {
    "deduplicationId": "test-deduplication-id",
    "time": "2026-05-15T11:30:00Z",
    "deviceInfo": {
        "applicationId": APPLICATION_ID,
        "applicationName": "powerline-monitoring",
        "deviceName": "test-end-device",
        "devEui": DEV_EUI,
    },
    "devAddr": "26011ABC",
    "adr": True,
    "fCnt": 12345,
    "fPort": 1,
    "confirmed": False,
    "data": build_test_payload(),
    "rxInfo": [
        {
            "gatewayId": GATEWAY_ID,
            "uplinkId": 999001,
            "rssi": -87,
            "snr": 7.5,
            "channel": 1,
            "crcStatus": "CRC_OK",
        }
    ],
    "txInfo": {
        "frequency": 868300000,
        "modulation": {
            "lora": {
                "bandwidth": 125000,
                "spreadingFactor": 12,
                "codeRate": "CR_4_5",
            }
        }
    }
}


def main():
    client = mqtt.Client(
        callback_api_version=mqtt.CallbackAPIVersion.VERSION2,
        client_id="test_lora_metadata_event_sender",
    )

    client.tls_set(ca_certs=MQTT_CA_CERT_PATH)
    client.tls_insecure_set(False)

    client.connect(MQTT_BROKER, MQTT_PORT, 60)
    client.loop_start()

    result = client.publish(TOPIC, json.dumps(event))
    result.wait_for_publish()

    print(f"Published test event to {TOPIC}, rc={result.rc}")

    client.loop_stop()
    client.disconnect()


if __name__ == "__main__":
    main()
