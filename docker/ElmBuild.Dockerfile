# From https://github.com/based-template/building-elm-from-source
# From https://www.haskell.org/ghcup/install/
FROM ubuntu:23.04 AS elm
ENV PATH=/root/.ghcup/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN apt update
RUN apt install -y wget build-essential curl libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev pkg-config zlib1g-dev
RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
RUN ghcup install ghc 8.4.3 && ghcup install cabal 2.4.1
RUN ghcup set ghc 8.4.3 && ghcup set cabal 2.4.1
RUN wget https://github.com/elm/compiler/archive/refs/tags/0.19.1.tar.gz
RUN tar -xvzf ./0.19.1.tar.gz
RUN cd compiler-0.19.1/ && rm worker/elm.cabal && cabal new-update && cabal new-configure --ghc-option=-optl=-pthread && cabal new-build
RUN cp compiler-0.19.1/dist-newstyle/build/*/ghc-8.4.3/elm-0.19.1/x/elm/build/elm/elm /
RUN chmod 777 /elm

FROM scratch
COPY --from=elm /elm /elm