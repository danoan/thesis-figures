cmake_minimum_required(VERSION 3.2)
project(ch6-unlabeled-ratio)


set(INCLUDE_DIRS
        include
        ${BOOST_INCLUDE_DIRS}
        ${JMIV_DIPACUS_INCLUDE_DIRS}
        ${JMIV_SCABOLIC_INCLUDE_DIRS}
        ${JMIV_BTOOLS_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

set(LINK_LIBS -lbtools-reader
        -lbtools-core
        -lbtools-utils
        -lscabolic-optimization
        -lscabolic-energy
        -lscabolic-core
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lgcurve
        -lgcurve-utils
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})

add_executable(ch6-unlabeled-ratio ch6-unlabeled-ratio.cpp
        src/energyUtils.cpp
        src/countUnlabeled.cpp
        src/utils.cpp)

add_dependencies(ch6-unlabeled-ratio btools-jmiv )

target_link_directories(ch6-unlabeled-ratio PRIVATE
        ${JMIV_DIPACUS_LIBS_DIR}
        ${JMIV_SCABOLIC_LIBS_DIR}
        ${JMIV_BTOOLS_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_include_directories(ch6-unlabeled-ratio PRIVATE ${INCLUDE_DIRS})
target_link_libraries(ch6-unlabeled-ratio ${LINK_LIBS})
