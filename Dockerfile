ARG K_COMMIT
FROM runtimeverificationinc/kframework-k:ubuntu-bionic-${K_COMMIT}

RUN    apt-get update              \
    && apt-get upgrade --yes       \
    && apt-get install --yes       \
                       cmake       \
                       pandoc      \
                       python3     \
                       python3-pip

RUN    git clone 'https://github.com/z3prover/z3' --branch=z3-4.8.11 \
    && cd z3                                                         \
    && python scripts/mk_make.py                                     \
    && cd build                                                      \
    && make -j8                                                      \
    && make install                                                  \
    && cd ../..                                                      \
    && rm -rf z3

ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g $GROUP_ID user && useradd -m -u $USER_ID -s /bin/sh -g user user

USER user:user
WORKDIR /home/user

RUN pip3 install         \
                 cytoolz \
                 numpy

RUN    git clone 'https://github.com/WebAssembly/wabt' --branch 1.0.13 --recurse-submodules wabt \
    && cd wabt                                                                                   \
    && mkdir build                                                                               \
    && cd build                                                                                  \
    && cmake ..                                                                                  \
    && cmake --build .

ENV PATH=/home/user/wabt/build:/home/user/.local/bin:$PATH
