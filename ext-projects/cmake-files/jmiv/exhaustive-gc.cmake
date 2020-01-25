ExternalProject_Add(exhaustive-gc-jmiv
        GIT_REPOSITORY https://github.com/danoan/exhaustive-gc.git
        GIT_TAG v0.2
        SOURCE_DIR ${EXTPROJECTS_SOURCE_DIR}/jmiv/exhaustive-gc
        CMAKE_ARGS
        -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${EXTPROJECTS_BUILD_DIR}/jmiv
        -DDIPACUS_INCLUDE_DIRS=${EXTPROJECTS_BUILD_DIR}/jmiv/include
        -DDIPACUS_LIBS_DIR=${EXTPROJECTS_BUILD_DIR}/jmiv/lib
        -DGCURVE_INCLUDE_DIRS=${EXTPROJECTS_BUILD_DIR}/jmiv/include
        -DGCURVE_LIBS_DIR=${EXTPROJECTS_BUILD_DIR}/jmiv/lib
        -DGEOC_INCLUDE_DIRS=${EXTPROJECTS_BUILD_DIR}/jmiv/include
        -DUSE_REMOTE_REPOSITORIES=OFF
        -DCREATE_SHARED_LIBRARIES=ON
        -DBUILD_APPLICATIONS=ON
        -DBOOST_INCLUDE_DIRS=${BOOST_INCLUDE_DIRS}
        -DBOOST_LIBS_DIR=${BOOST_LIBS_DIR})

add_dependencies(exhaustive-gc-jmiv dipacus-jmiv gcurve-jmiv geoc-jmiv magLac-jmiv)