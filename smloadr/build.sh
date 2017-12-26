#!/bin/bash

git clone https://gitlab.com/SMLoadrDev/SMLoadr

docker build . --tag starbix/smloadr

docker push starbix/smloadr
