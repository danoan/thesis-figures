cmake_minimum_required(VERSION 3.2)
project(ch4-dss-perimeter-estimator)

add_executable(ch4-dss-perimeter-estimator ch4-dss-perimeter-estimator.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(ch4-dss-perimeter-estimator dipacus)
endif()

target_include_directories( ch4-dss-perimeter-estimator PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories( ch4-dss-perimeter-estimator PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries( ch4-dss-perimeter-estimator
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})