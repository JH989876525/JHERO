#!/bin/bash

echo "cleaning trash"

sudo rm -f ./vivado*.log
sudo rm -f ./vivado*.jou
sudo rm -f ./vivado*.str
sudo rm -f ./vitis*.str
sudo rm -f ./hs_err*.str
sudo rm -f ./hs_err*.log
sudo rm -f ./xrc.log
sudo rm -rf ./Xil
sudo rm -rf ~/.local/share/Trash/*
sudo rm -rf /media/jhh/ExtraSSD/.Trash-1000/*
sudo rm -rf /media/jhh/2022/.Trash-1000/*
sudo rm -rf /media/jhh/2023/.Trash-1000/*
sudo trash-empty

echo "cleaning swap"

sudo swapoff -a
