#!/bin/bash

git clone https://gitlab.com/SMLoadrDev/SMLoadrDesktop

docker build . --tag starbix/smloadr

docker push starbix/smloadr
