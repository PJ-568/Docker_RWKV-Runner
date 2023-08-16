FROM debian
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install git wget python3-dev curl gnupg2 -y
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update
RUN apt install yarn -y
RUN echo 'mkdir /RWKV-Next-Web' >>/RWKV.sh
RUN echo 'cd /RWKV-Next-Web' >>/RWKV.sh
RUN echo 'git clone https://github.com/josStorer/RWKV-Runner --depth=1' >>/RWKV.sh
RUN echo 'python3 -m pip install torch torchvision torchaudio' >>/RWKV.sh
RUN echo 'python3 -m pip install -r RWKV-Runner/backend-python/requirements.txt' >>/RWKV.sh
RUN echo 'python3 ./RWKV-Runner/backend-python/main.py > log.txt &' >>/RWKV.sh
RUN echo 'if [ ! -d RWKV-Runner/models ]; then' >>/RWKV.sh
RUN echo '    mkdir RWKV-Runner/models' >>/RWKV.sh
RUN echo 'fi' >>/RWKV.sh
RUN echo 'wget -N https://huggingface.co/BlinkDL/rwkv-4-world/resolve/main/RWKV-4-World-CHNtuned-1.5B-v1-20230620-ctx4096.pth -P RWKV-Runner/models/' >>/RWKV.sh
RUN echo 'git clone https://github.com/Yidadaa/ChatGPT-Next-Web --depth=1' >>/RWKV.sh
RUN echo 'cd /RWKV-Next-Web/ChatGPT-Next-Web' >>/RWKV.sh
RUN echo 'yarn install' >>/RWKV.sh
RUN echo 'yarn build' >>/RWKV.sh
RUN echo 'cd /RWKV-Next-Web/ChatGPT-Next-Web' >>/Start_RWKV.sh
RUN echo 'export PROXY_URL=""' >>/Start_RWKV.sh
RUN echo 'export BASE_URL=http://127.0.0.1:8000' >>/Start_RWKV.sh
RUN echo 'yarn start &' >>/Start_RWKV.sh
RUN echo 'curl http://127.0.0.1:8000/switch-model -X POST -H "Content-Type: application/json" -d '{"model":"./RWKV-Runner/models/RWKV-4-World-CHNtuned-1.5B-v1-20230620-ctx4096.pth","strategy":"cpu fp32"}'' >>/Start_RWKV.sh
RUN chmod 755 /RWKV.sh
RUN chmod 755 /Start_RWKV.sh
RUN sh /RWKV.sh
EXPOSE 80
CMD  /Start_RWKV.sh
