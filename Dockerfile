FROM dockcross/manylinux-x64

# "Install" Eigen
RUN git clone --progress --verbose https://github.com/eigenteam/eigen-git-mirror.git \
    && cp -r eigen-git-mirror/Eigen/ /usr/include/

# Build and install Boost  
RUN curl -L -o boost.tar.bz2 https://sourceforge.net/projects/boost/files/boost/1.61.0/boost_1_61_0.tar.bz2
RUN tar --bzip2 -xf boost.tar.bz2
# Note that we are NOT installing Boost.Python
RUN cd boost_1_61_0 && ./bootstrap.sh --with-libraries=thread atomic chrono container context coroutine coroutine2 date_time exception filesystem graph graph_parallel iostream locale log math metaparse mpi program_options random regex serialization signals system test timer type_erasure wave && ./b2 install --prefix=/usr/local/ 

# Build and install opencv
RUN curl -L -o opencv.zip https://github.com/opencv/opencv/archive/3.4.3.zip && \
    unzip opencv.zip
RUN cd opencv-3.4.3 && mkdir build && cd build && \
    cmake -D WITH_TBB=ON -D WITH_OPENMP=ON -D WITH_IPP=ON -D CMAKE_BUILD_TYPE=RELEASE -D BUILD_EXAMPLES=OFF -D BUILD_DOCS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF -D WITH_CSTRIPES=ON -D WITH_OPENCL=ON CMAKE_INSTALL_PREFIX=/usr/local/ .. && \
    make && make install

RUN yum install openblas-devel -y

RUN yum install lapack-devel -y

RUN yum install suitesparse-devel -y