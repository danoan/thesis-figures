ExternalProject_Add(gcurve-jmiv
        GIT_REPOSITORY https://github.com/danoan/GCurve.git
        GIT_TAG v0.2
        SOURCE_DIR ${EXTPROJECTS_SOURCE_DIR}/jmiv/GCurve
        CMAKE_ARGS
        -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${EXTPROJECTS_BUILD_DIR}/jmiv
        -DUSE_REMOTE_REPOSITORIES=OFF
        -DDIPACUS_INCLUDE_DIRS=${EXTPROJECTS_BUILD_DIR}/jmiv/include
        -DDIPACUS_LIBS_DIR=${EXTPROJECTS_BUILD_DIR}/jmiv/lib
        -DCREATE_SHARED_LIBRARIES=ON)

add_dependencies(gcurve-jmiv dipacus-jmiv)