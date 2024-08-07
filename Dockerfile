# CUDA 11.8을 지원하는 베이스 이미지 사용
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

# 필요한 패키지 설치
RUN apt-get update && apt-get install -y \
    wget \
    git \
    python3.10 \
    python3-pip \
    vim

# 필요한 패키지 설치
RUN pip install --upgrade pip 

# Flash Attention 설치
RUN wget https://github.com/Dao-AILab/flash-attention/releases/download/v2.4.2/flash_attn-2.4.2+cu118torch2.0cxx11abiFALSE-cp310-cp310-linux_x86_64.whl && \
    pip install flash_attn-2.4.2+cu118torch2.0cxx11abiFALSE-cp310-cp310-linux_x86_64.whl

# 현재 디렉토리의 내용을 컨테이너로 복사
COPY . /app

WORKDIR /app

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# 패키지 설치 및 설정
RUN pip3 install -e . && \
    pip3 install -e ".[train]" && \
    pip3 install git+https://github.com/huggingface/transformers@v4.36.2

# transformers 패키지 설정
RUN site_pkg_path=$(python3 -c 'import site; print(site.getsitepackages()[0])') && \
    cp -rv ./llava/train/transformers_replace/* $site_pkg_path/transformers/

# rmdir app/
RUN rm -rf /app

# 컨테이너 실행 시 기본 명령어 설정
CMD ["/bin/bash"]
