#!/bin/bash

# Deployment script for price_feed.cairo

# Declare the contract and capture the command output
command_output=$(starkli declare ../../target/dev/satoru_PriceFeed.sierra.json --network=goerli-1 --compiler-version=2.1.0 --account $1 --keystore $2)

from_string="Class hash declared:"
class_hash="${command_output#*$from_string}"

# Deploy the contract using the extracted class hash
starkli deploy $class_hash --network=goerli-1 --account $1 --keystore $2