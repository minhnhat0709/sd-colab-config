#!/bin/bash

echo "Worker Initiated"

# echo "Starting WebUI API"
# python /stable-diffusion-webui/webui.py --controlnet-annotator-models-path  /stable-diffusion-webui/controlnet_annotation --ckpt /runpod-volume/stable-diffusion-webui/models/Stable-diffusion/realisticVisionV51_v30VAE.safetensors  --ckpt-dir /runpod-volume/stable-diffusion-webui/models/Stable-diffusion --lora-dir /runpod-volume/stable-diffusion-webui/models/Lora  --skip-python-version-check --skip-torch-cuda-test --skip-install  --lowram --opt-sdp-attention --disable-safe-unpickle --port 3000 --api --nowebui --skip-version-check  --no-hashing --no-download-sd-model &

# echo "Starting RunPod Handler"
# python -u /rp_handler.py

# --controlnet-dir /runpod-volume/stable-diffusion-webui/models/ControlNet
pip install onnx onnxruntime-gpu

aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://civitai.com/api/download/models/44716 -d /stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_canny_fp16.safetensors && \
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://civitai.com/api/download/models/44736 -d /stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_depth_fp16.safetensors && \
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://civitai.com/api/download/models/44876 -d /stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_inpaint_fp16.safetensors && \
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://civitai.com/api/download/models/44877 -d /stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_lineart_fp16.safetensors && \
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://civitai.com/api/download/models/44795 -d /stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_mlsd_fp16.safetensors && \
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://civitai.com/api/download/models/44774 -d /stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_normalbae_fp16.safetensors && \
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://civitai.com/api/download/models/44811 -d /stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_openpose_fp16.safetensors && \
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://civitai.com/api/download/models/44787 -d /stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_scribble_fp16.safetensors && \
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://civitai.com/api/download/models/44815 -d /stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_seg_fp16.safetensors && \
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://civitai.com/api/download/models/44756 -d /stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_softedge_fp16.safetensors && \
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://civitai.com/api/download/models/67566 -d /stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1e_sd15_tile_fp16.safetensors

wget -O "/stable-diffusion-webui/models/SAM/mobile_sam(vit_t).pt" https://github.com/ChaoningZhang/MobileSAM/raw/master/weights/mobile_sam.pt
export MAX_MEMORY_CAPACITY=30

cd /stable-diffusion-webui

git clone --depth 1 --branch main https://github.com/minhnhat0709/eliai-engine-sd-webui-ext extensions/eliai-engine-sd-webui-ext
cd extensions/eliai-engine-sd-webui-ext
git checkout main
cd ../..


while true; do
	if ! lsof -i:5456 -sTCP:LISTEN > /dev/null
	then
    		python ./webui.py --nowebui --api --xformers --port 5456 --listen > /engine_1.txt 2>&1 &
	fi
	sleep 1m
done
