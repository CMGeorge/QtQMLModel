#!/bin/sh
cd "$(dirname "$0")" ;
echo "=============Preparing QQmlModels================="
#should test command execution status
make clean
qmake -spec macx-ios-clang CONFIG+=iphoneos CONFIG+=device
make qmake_all
echo "Making QQmlModels Library"
make -j 8 --silent -w  > /dev/null
echo "Installing QQmlModels"
make install
cd $cwd
echo "\n\n"
