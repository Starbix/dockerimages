#!/bin/bash

docker build . --tag starbix/smloadr --no-cache && docker push starbix/smloadr
