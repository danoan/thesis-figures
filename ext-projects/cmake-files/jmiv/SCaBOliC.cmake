ExternalProject_Add(scabolic-jmiv
        GIT_REPOSITORY https://github.com/danoan/SCaBOliC.git
        GIT_TAG v0.2
        SOURCE_DIR ${EXTPROJECTS_SOURCE_DIR}/jmiv/SCaBOliC
        CMAKE_ARGS
        -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${EXTPROJECTS_BUILD_DIR}/jmiv
        -DUSE_REMOTE_REPOSITORIES=OFF
        -DDIPACUS_INCLUDE_DIRS=${EXTPROJECTS_BUILD_DIR}/jmiv/include
        -DDIPACUS_LIBS_DIR=${EXTPROJECTS_BUILD_DIR}/jmiv/lib
        -DGEOC_INCLUDE_DIRS=${EXTPROJECTS_BUILD_DIR}/jmiv/include
        -DBOOST_LIBS_DIR=${BOOST_LIBS_DIR}
        -DCREATE_SHARED_LIBRARIES=ON
        -DBUILD_TESTS=OFF
        -DBUILD_APPLICATIONS=OFF)

add_dependencies(scabolic-jmiv dipacus-jmiv geoc-jmiv)