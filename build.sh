#!/bin/bash

git clone https://gitlab.com/SMLoadrDev/SMLoadrDesktop
git -C SMLoadrDesktop pull

docker build . --tag starbix/smloadr --no-cache

docker push starbix/smloadr
