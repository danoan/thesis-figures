ExternalProject_Add(dipacus-jmiv
        GIT_REPOSITORY https://github.com/danoan/DIPaCUS.git
        GIT_TAG v0.2
        SOURCE_DIR ${EXTPROJECTS_SOURCE_DIR}/jmiv/DIPaCUS
        CMAKE_ARGS
        -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${EXTPROJECTS_BUILD_DIR}/jmiv
        -DCREATE_SHARED_LIBRARIES=ON)