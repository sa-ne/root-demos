#!/usr/bin/env bash

cd data-model && ./setup.sh && cd -
cd api-gateway && ./setup.sh && cd -
cd user && ./setup.sh && cd -
cd basket && ./setup.sh && cd -
cd inventory && ./setup.sh && cd -
cd web && ./setup.sh && cd -