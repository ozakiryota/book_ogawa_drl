########## Pull ##########
FROM nvidia/cuda:11.6.2-base-ubuntu20.04
########## User ##########
ARG home_dir="/home/user"
COPY copy/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN apt-get update && \
	apt-get install -y \
		gosu \
		sudo && \
	chmod +x /usr/local/bin/entrypoint.sh && \
	mkdir -p $home_dir
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
########## Non-interactive ##########
ENV DEBIAN_FRONTEND=noninteractive
########## Common Tools ##########
RUN apt-get update && \
    apt-get install -y \
	    vim \
    	wget \
    	unzip \
    	git \
		python3-tk
########## PyTorch ##########
RUN apt-get update && \
    apt-get install -y \
	    python3-pip && \
	pip3 install \
		torch==1.12.1+cu116 \
		torchvision==0.13.1+cu116 \
		torchaudio==0.12.1 \
		--extra-index-url https://download.pytorch.org/whl/cu116
########## Requirements ##########
RUN apt-get update && \
	apt-get install -y \
		python-opengl \
		ffmpeg \
		unrar && \
	pip3 install \
		jupyter \
		matplotlib \
		numpy==1.23.1 \
		gym==0.17.1 \
		pyglet==1.5.27 \
		JSAnimation \
		scikit-learn \
		pandas \
		atari_py \
		opencv-python \
		tqdm \
		tensorflow && \
	cd /usr/local/lib/python3.8/dist-packages/JSAnimation && \
	sed -i -e 's/, clear_temp=False//g' html_writer.py && \
	sed -i -e 's/self._temp_names/self._temp_paths/g' html_writer.py && \
	sed -i -e "s/return ('', '')/return (''.encode('utf-8'), ''.encode('utf-8'))/g" html_writer.py && \
	cd /tmp && \
	wget http://www.atarimania.com/roms/Roms.rar && \
	mkdir rom && \
	unrar e -y Roms.rar ./rom && \
	python3 -m atari_py.import_roms ./rom && \
	git clone https://github.com/openai/baselines.git && \
	cd baselines && \
	pip3 install -e .
########## Cache Busting ##########
ARG cache_bust=1
########## Book ##########
RUN cd $home_dir && \
	git clone https://github.com/YutaroOgawa/Deep-Reinforcement-Learning-Book && \
	cd Deep-Reinforcement-Learning-Book/program && \
	sed -i -e 's/mnist.data/mnist.data.to_numpy()/g' 4_3_PyTorch_MNIST.ipynb && \
	sed -i -e 's/current_obs\[:, :-1\] = current_obs\[:, 1:\]/current_obs\[:, :-1\] = current_obs.clone()\[:, 1:\]/g' 7_breakout_play.ipynb
########## Initial Position ##########
WORKDIR $home_dir/Deep-Reinforcement-Learning-Book
CMD ["bash"]