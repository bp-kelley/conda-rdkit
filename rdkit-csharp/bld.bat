rem surely there's a better way than this
if "%PY_VER%"=="2.7" (
	set PYTHON_LIBRARY=python27.lib
) else if  "%PY_VER%"=="3.4" (
	set PYTHON_LIBRARY=python34.lib
) else if  "%PY_VER%"=="3.5" (
	set PYTHON_LIBRARY=python35.lib
) else (
	echo "Unexpected version of python"
	exit 1
)

set > env.bat 2>&1
cmake ^
    -G "NMake Makefiles" ^
    -D RDK_INSTALL_INTREE=ON ^
    -D RDK_BUILD_INCHI_SUPPORT=ON ^
    -D RDK_BUILD_AVALON_SUPPORT=ON ^
    -D RDK_USE_FLEXBISON=OFF ^
    -D Python_ADDITIONAL_VERSIONS=${PY_VER} ^
    -D PYTHON_EXECUTABLE="%PYTHON%" ^
    -D PYTHON_INCLUDE_DIR="%PREFIX%\include" ^
    -D PYTHON_LIBRARY="%PREFIX%\libs\%PYTHON_LIBRARY%" ^
    -D PYTHON_INSTDIR="%SP_DIR%" ^
    -D BOOST_ROOT="%LIBRARY_PREFIX%" -D Boost_NO_SYSTEM_PATHS=ON ^
    -D CMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -D CMAKE_BUILD_TYPE=Release ^
    -D RDK_SQUASH_MVC_SECURE_WARNINGS=On ^
    -D RDK_BUILD_SWIG_WRAPPERS=On ^
    -D RDK_BUILD_SWIG_JAVA_WRAPPER=Off ^
    -D RDK_BUILD_SWIG_CSHARP_WRAPPER=On -D RDK_BUILD_PYTHON_WRAPPERS=Off ^
    .
    
set CL=/MP
nmake

set RDBASE=%SRC_DIR%
set PYTHONPATH=%RDBASE%

nmake test
%PYTHON% "%RECIPE_DIR%\pkg_version.py"

nmake install
explorer .
