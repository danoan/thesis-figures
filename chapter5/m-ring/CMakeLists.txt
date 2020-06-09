cmake_minimum_required(VERSION 3.2)
project(ch5-m-ring)

add_executable(ch5-m-ring ch5-m-ring.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(ch5-m-ring dipacus)
endif()

target_include_directories(ch5-m-ring PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${SCABOLIC_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(ch5-m-ring PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${SCABOLIC_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries(ch5-m-ring
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})