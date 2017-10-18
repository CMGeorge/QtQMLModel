CALL mingw32-make distclean --silent
CALL qmake -spec win32-g++ -config +=warn_off CONFIG+=warn_off
CALL mingw32-make qmake_all --silent
echo "Making QQmlModels Library"
CALL mingw32-make -j 8 --silent
echo "Installing QQmlModels"
CALL mingw32-make -j 1 --silent install 
