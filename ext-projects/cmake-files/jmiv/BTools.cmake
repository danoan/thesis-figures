ExternalProject_Add(btools-jmiv
        GIT_REPOSITORY https://github.com/danoan/BTools.git
        GIT_TAG v0.2
        SOURCE_DIR ${EXTPROJECTS_SOURCE_DIR}/jmiv/BTools
        CMAKE_ARGS
        -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_INSTALL_PREFIX=${EXTPROJECTS_BUILD_DIR}/jmiv
        -DUSE_REMOTE_REPOSITORIES=OFF
        -DDIPACUS_INCLUDE_DIRS=${EXTPROJECTS_BUILD_DIR}/jmiv/include
        -DDIPACUS_LIBS_DIR=${EXTPROJECTS_BUILD_DIR}/jmiv/lib
        -DSCABOLIC_INCLUDE_DIRS=${EXTPROJECTS_BUILD_DIR}/jmiv/include
        -DSCABOLIC_LIBS_DIR=${EXTPROJECTS_BUILD_DIR}/jmiv/lib
        -DBOOST_INCLUDE_DIRS=${BOOST_INCLUDE_DIRS}
        -DBOOST_LIBS_DIR=${BOOST_LIBS_DIR}
        -DBUILD_FIGURES=OFF
        -DGEOC_INCLUDE_DIRS=${EXTPROJECTS_BUILD_DIR}/jmiv/include
        -DCREATE_SHARED_LIBRARIES=ON)

add_dependencies(btools-jmiv scabolic-jmiv dipacus-jmiv geoc-jmiv)