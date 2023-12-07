#!/bin/bash

echo "Worker Initiated"

numberOfEngines=$NUMBER_OF_ENGINES 

# Loop through the array and echo each substring
for ((i=1; i<=numberOfEngines; i++)); do
  port=$((5000 + i))
  echo "running in port: $port"
  echo "Starting WebUI API"
  python /workspace/stable-diffusion-webui/webui.py --skip-python-version-check --skip-torch-cuda-test --opt-sdp-attention --disable-safe-unpickle --port $port --api --nowebui --skip-version-check --listen --no-hashing --no-download-sd-model &
done



# echo "Starting RunPod Handler"
# python -u /rp_handler.py
