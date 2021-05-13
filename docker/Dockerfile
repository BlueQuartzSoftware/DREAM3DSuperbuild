FROM library/ubuntu:18.04 AS build
LABEL Author="BlueQuartz Software <info@bluequartz.net>"

# Define the version of CMake that we will be using. We are downloading it directly from
# Kitware servers
ENV CMAKE_VERSION=3.19
ENV CMAKE_PATCH=8
ENV CMAKE_NAME=cmake-$CMAKE_VERSION.$CMAKE_PATCH-Linux-x86_64

# define the version of Qt5 that we are going to use.
ENV QT_MAJOR=5
ENV QT_MINOR=15
ENV QT_PATCH=2

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install software-properties-common && \
  add-apt-repository ppa:beineri/opt-qt-$QT_MAJOR.$QT_MINOR.$QT_PATCH-bionic && \
  apt-get update && \
  apt-get -y install \
  qt${QT_MAJOR}${QT_MINOR}base \
  qt${QT_MAJOR}${QT_MINOR}x11extras \
  qt${QT_MAJOR}${QT_MINOR}svg \
  qt${QT_MAJOR}${QT_MINOR}tools

RUN apt-get -y install \
  wget \
  git \
  build-essential \
  fontconfig \
  dbus \
  libx11-6 \
  libx11-xcb1 \
  libgl1-mesa-dev \
  libpython3.5 \
  python3 \
  python3-distutils \
  python3-pip \
  ninja-build

RUN add-apt-repository ppa:ubuntu-toolchain-r/test && \
  apt-get update && \
  apt-get -y install gcc-9 g++-9


ENV CC=/usr/bin/gcc-9
ENV CXX=/usr/bin/g++-9

# Load up the mkdocs python modules
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN /usr/bin/pip3 install mkdocs-material numpy imageio


# Define the remaining variables that will be needed during the build of the image
ENV DREAM3D_SDK=/opt/DREAM3D_SDK
ENV CMAKE_BUILD_TYPE=Release
ENV GIT_BRANCH=develop
ENV WORKSPACE=/opt/DREAM3D-Dev
ENV SDK_SOURCE_DIR=$DREAM3D_SDK/dream3dsuperbuild
ENV SDK_BUILD_DIR=$SDK_SOURCE_DIR/$CMAKE_BUILD_TYPE
ENV WORKSPACE_BUILD=$WORKSPACE/Build

# Create the DREAM3D_SDK Directory
RUN mkdir -p $DREAM3D_SDK && \
  chmod -R 0777 $DREAM3D_SDK && \
  # Install CMake 3.x
  cd $DREAM3D_SDK && \
  wget https://cmake.org/files/v$CMAKE_VERSION/$CMAKE_NAME.tar.gz && \
  tar -xzf $CMAKE_NAME.tar.gz && \
  rm -rf $CMAKE_NAME.tar.tgz

# Use CMake to configure the SDK build...
RUN echo "Cloning DREAM3DSuperbuild..." && \
  PATH=$PATH:/opt/qt515/bin && \
  # clone the DREAM3DSuperbuild repo
  cd $DREAM3D_SDK && \
  git clone -b develop https://github.com/bluequartzsoftware/dream3dsuperbuild && \
  # Create a directory for the CMake configuration of the DREAM3D SDK
  mkdir -p $SDK_BUILD_DIR && \
  cd $SDK_BUILD_DIR && \
  $DREAM3D_SDK/$CMAKE_NAME/bin/cmake \
  -DDREAM3D_SDK=$DREAM3D_SDK \
  -DINSTALL_QT5=OFF \
  -DBUILD_TBB=ON \
  -DQt5_QMAKE_EXECUTABLE=/opt/qt${QT_MAJOR}${QT_MINOR}/bin/qmake \
  -Dqt5_version_full=${QT_MAJOR}.$QT_MINOR.$QT_PATCH \
  -DQt5_DIR=/opt/qt${QT_MAJOR}${QT_MAJOR}/lib/cmake/Qt${QT_MAJOR} \
  -DBUILD_ITK=ON \
  -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
  $SDK_SOURCE_DIR

# Build the DREAM3D SDK by compiling sources or downloading prebuilt binaries
# Be sure to untar the data directories so that the installation will work
RUN cd $SDK_BUILD_DIR && \
  export PATH=$PATH:/opt/qt${QT_MAJOR}${QT_MAJOR}/bin && \
  make -j "$(nproc)" && \
  cd $DREAM3D_SDK/DREAM3D_Data/Data && \
  tar -xzf SmallIN100.tar.gz && \
  tar -xzf Image.tar.gz && \
  # Remove the entire DREAM3D_SDK Build directory
  rm $DREAM3D_SDK/cmake-$CMAKE_VERSION.$CMAKE_PATCH-Linux-x86_64.tar.gz && \
  rm -rf $DREAM3D_SDK/superbuild/CMP && \
  rm -rf $DREAM3D_SDK/superbuild/discount && \
  rm -rf $DREAM3D_SDK/superbuild/DREAM3D_Data && \
  rm -rf $DREAM3D_SDK/superbuild/Eigen && \
  rm -rf $DREAM3D_SDK/superbuild/haru && \
  rm -rf $DREAM3D_SDK/superbuild/hdf5 && \
  rm -rf $DREAM3D_SDK/superbuild/pybind11 && \
  rm -rf $DREAM3D_SDK/superbuild/qwt && \
  rm -rf $DREAM3D_SDK/superbuild/tbb

# Clone all of the DREAM3D Sources
RUN mkdir -p $WORKSPACE && \
  cd $WORKSPACE && \
  git clone -b develop https://github.com/bluequartzsoftware/CMP && \
  git clone -b develop https://github.com/bluequartzsoftware/SIMPL && \
  git clone -b develop https://github.com/bluequartzsoftware/SIMPLView && \
  git clone -b develop https://github.com/bluequartzsoftware/H5Support && \
  git clone -b develop https://github.com/bluequartzsoftware/EbsdLib && \
  git clone -b develop https://github.com/bluequartzsoftware/DREAM3D && \
  mkdir -p $WORKSPACE/DREAM3D_Plugins && \
  cd $WORKSPACE/DREAM3D_Plugins && \
  git clone -b develop https://github.com/bluequartzsoftware/ITKImageProcessing && \
  git clone -b develop https://github.com/bluequartzsoftware/SimulationIO && \
  git clone -b develop https://github.com/dream3d/ImageProcessing && \
  git clone -b develop https://github.com/dream3d/DREAM3DReview && \
  git clone -b develop https://github.com/dream3d/UCSBUtilities

# Configure DREAM3D to build 
RUN mkdir -p $WORKSPACE_BUILD && \
  cd $WORKSPACE_BUILD && \
  $DREAM3D_SDK/$CMAKE_NAME/bin/cmake \
  -G Ninja \
  -DDREAM3D_SDK=$DREAM3D_SDK \
  -DQt5_DIR=/opt/qt515/lib/cmake/Qt5 \
  -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
  -DSIMPL_EMBED_PYTHON=ON \
  -DSIMPL_WRAP_PYTHON=ON \
  $WORKSPACE/DREAM3D

# Compile DREAM3D 
RUN cd $WORKSPACE_BUILD && \
  $DREAM3D_SDK/$CMAKE_NAME/bin/cmake --build . --target all

# We might want to create a Python Virtual Environment and install DREAM3D into that?

# Create an Entry point that just runs the unit tests using CTest
RUN echo "#!/bin/bash" > /build.sh && \
  echo "echo 'hello world'" >> /build.sh && \
  echo "set -e" >> build.sh >> /build.sh && \
  echo "cd $WORKSPACE_BUILD" >> /build.sh && \
  echo "export PATH=$PATH:$WORKSPACE_BUILD/Bin" >> /build.sh && \
  echo "$DREAM3D_SDK/cmake-$CMAKE_VERSION.$CMAKE_PATCH-Linux-x86_64/bin/ctest --verbose -R" >> build.sh && \
  chmod u+x /build.sh

ENTRYPOINT ["/build.sh"]

ARG BUILD_DATE
ARG IMAGE=dream3d/dream3d:dream3d
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name=$IMAGE \
  org.label-schema.description="Image containing DREAM.3D environment to build and test DREAM3D" \
  org.label-schema.url="https://github.com/bluequartzsoftware/dream3d" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url=$VCS_URL \
  org.label-schema.schema-version="1.0"

