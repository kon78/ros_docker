#!/bin/bash
echo "$0 - prepare package beginner_tutorials."

cd /app/data

tar -xvf bt.tar #extract package
cp -r beginner_tutorials /opt/ros/noetic/share
