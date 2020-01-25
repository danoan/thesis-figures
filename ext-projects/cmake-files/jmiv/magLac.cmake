ExternalProject_Add(magLac-jmiv
        GIT_REPOSITORY https://github.com/danoan/magLac.git
        GIT_TAG v0.1
        SOURCE_DIR ${EXTPROJECTS_SOURCE_DIR}/jmiv/magLac
        CMAKE_ARGS
        -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${EXTPROJECTS_BUILD_DIR}/jmiv
        -DBOOST_LIBS_DIR=${BOOST_LIBS_DIR}
        -DBOOST_INCLUDE_DIRS=${BOOST_INCLUDE_DIRS})