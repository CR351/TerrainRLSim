FROM nvidia/cudagl:9.0-runtime-ubuntu16.04

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    git \
    mesa-utils \
    libboost-all-dev

RUN apt-get update && apt-get install -y \
    libprotobuf-dev \
    libleveldb-dev \
    libsnappy-dev \
    libopencv-dev \
    libhdf5-serial-dev\
    protobuf-compiler \
    libgflags-dev \
    libgoogle-glog-dev \
    liblmdb-dev \
    libatlas-base-dev \
    gcc-4.9-multilib \
    g++-4.9-multilib \
    libf2c2-dev \
    libglew-dev \
    freeglut3 \
    freeglut3-dev \
    premake4 \
    cmake \
# Python wrapper(optional)
    swig3.0 \
    python3-dev \
    python3-pip
    
# RUN wget https://github.com/xbpeng/DeepTerrainRL/\
#     releases/download/v1.0/TerrainRL-external-Linux.tar.gz \
#     tar -xvf TerrainRL-external-Linux.tar.gz.crdownload

# Copy from local to image
COPY /TerrainRLSim /terrain

# # # Build caffe
# RUN cd /terrain/external/caffe \
#     && make clean \
#     && make -j4 

# Copy compiled caffe lib
RUN cp -r /terrain/external/caffe/build/lib terrain/ \
# Copy prebuilt libraries from external
    && cp /terrain/external/caffe/build/lib/libcaffe.* lib/ \
    && cp /terrain/external/Bullet/bin/*.so lib/ \
    && cp /terrain/external/jsoncpp/build/debug/src/lib_json/*.so* lib/

RUN cd lib/ \
    && mv libBulletDynamics_gmake_x64_release.so libBulletDynamics_gmake_x64_debug.so \
    && mv libBulletCollision_gmake_x64_release.so libBulletCollision_gmake_x64_debug.so \
    && mv libLinearMath_gmake_x64_release.so libLinearMath_gmake_x64_debug.so

# RUN cd /terrain/simAdapter \
#     && chmod +x /gen_swig.sh \
#     && /gen_swig.sh \
#     && cd ../

# Create makefile using premake
RUN cd /terrain \
    && chmod +x ./premake4_linux \
    && ./premake4_linux clean \
    && ./premake4_linux gmake

# Build all targets
RUN cd terrain/gmake \
    && make config=debug64 -j4

RUN mv terrain/x64/Debug/* terrain/

WORKDIR /terrain