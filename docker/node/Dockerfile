FROM bitcoinnano/btco-env:gcc

ARG NETWORK=live
ARG TRAVIS_TAG=DEV_BUILD
ARG CI_BUILD=OFF
ADD ./ /tmp/src

RUN mkdir /tmp/build && \
    cd /tmp/build && \
    cmake /tmp/src -DCI_BUILD=${CI_BUILD} -DBOOST_ROOT=${BOOST_ROOT} -DACTIVE_NETWORK=btco_${NETWORK}_network \
    -DBTCO_ROCKSDB=ON -DBTCO_POW_SERVER=ON -DROCKSDB_LIBRARIES=/tmp/rocksdb/lib/librocksdb.a \
    -DROCKSDB_INCLUDE_DIRS=/tmp/rocksdb/include -DBTCO_SHARED_BOOST=ON && \
    make btco_node -j $(nproc) && \
    make btco_rpc -j $(nproc) && \
    make btco_pow_server -j $(nproc) && \
    cd .. && \
    echo ${NETWORK} > /etc/btco-network

FROM ubuntu:16.04

RUN groupadd --gid 1000 bitcoinnano && \
    useradd --uid 1000 --gid bitcoinnano --shell /bin/bash --create-home bitcoinnano

COPY --from=0 /tmp/build/btco_node /usr/bin
COPY --from=0 /tmp/build/btco_rpc /usr/bin
COPY --from=0 /tmp/build/btco_pow_server /usr/bin
COPY --from=0 /tmp/src/api/ /usr/bin/api/
COPY --from=0 /etc/btco-network /etc
COPY docker/node/entry.sh /usr/bin/entry.sh
COPY docker/node/config /usr/share/btco/config
COPY --from=0 /tmp/boost/lib/* /usr/local/lib/
RUN chmod +x /usr/bin/entry.sh
RUN ln -s /usr/bin/btco_node /usr/bin/rai_node
RUN ldconfig

WORKDIR /root
USER root

ENV PATH="${PATH}:/usr/bin"
ENTRYPOINT ["/bin/bash",  "/usr/bin/entry.sh"]
CMD ["btco_node daemon -l"]
