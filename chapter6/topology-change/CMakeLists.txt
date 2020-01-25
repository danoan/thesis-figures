cmake_minimum_required(VERSION 3.2)
project(ch6-topology-change)

add_executable(ch6-topology-change ch6-topology-change.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(ch6-topology-change btools-jmiv scabolic-jmiv dipacus-jmiv)
endif()


target_link_directories(ch6-topology-change PRIVATE
        ${JMIV_DIPACUS_LIBS_DIR}
        ${JMIV_SCABOLIC_LIBS_DIR}
        ${JMIV_BTOOLS_LIBS_DIR}
        ${CMAKE_PREFIX_PATH}
        ${BOOST_LIBS_DIR})

target_include_directories(ch6-topology-change PRIVATE
        include
        ${CMAKE_SOURCE_DIR}/modules/utils/include
        ${BOOST_INCLUDE_DIRS}
        ${JMIV_DIPACUS_INCLUDE_DIRS}
        ${JMIV_SCABOLIC_INCLUDE_DIRS}
        ${JMIV_BTOOLS_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_libraries(ch6-topology-change
        -lbtools-core
        -lbtools-reader
        -lbtools-utils
        -lscabolic-optimization
        -lscabolic-energy
        -lscabolic-core
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})