ExternalProject_Add(geoc-jmiv
        GIT_REPOSITORY https://github.com/danoan/GEOC.git
        GIT_TAG v0.2
        SOURCE_DIR ${EXTPROJECTS_SOURCE_DIR}/jmiv/GEOC
        CMAKE_ARGS
        -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${EXTPROJECTS_BUILD_DIR}/jmiv
        -DUSE_REMOTE_REPOSITORIES=OFF
        -DDIPACUS_INCLUDE_DIRS=${EXTPROJECTS_BUILD_DIR}/jmiv/include
        -DDIPACUS_LIBS_DIR=${EXTPROJECTS_BUILD_DIR}/jmiv/lib
        -DBOOST_LIBS_DIR=${BOOST_LIBS_DIR}
        -DBOOST_INCLUDE_DIRS=${BOOST_INCLUDE_DIRS}
        -DBUILD_APPS=ON)

add_dependencies(geoc-jmiv dipacus-jmiv gcurve-jmiv)