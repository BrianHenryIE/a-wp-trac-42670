#!/bin/bash

# Script which runs outside Docker

wp-env run cli ./single-symlink.sh;

wp-env run tests-cli ./double-symlink.sh;
