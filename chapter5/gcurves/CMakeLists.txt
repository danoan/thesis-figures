cmake_minimum_required(VERSION 3.2)
project(ch5-gcurves)

add_executable(ch5-gcurves ch5-gcurves.cpp
        src/distance-transform.cpp
        src/glued-curve.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(ch5-gcurves btools scabolic dipacus exhaustive-gc gcurve)
endif()

target_include_directories(ch5-gcurves PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${SCABOLIC_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(ch5-gcurves PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${SCABOLIC_LIBS_DIR}
        ${BTOOLS_LIBS_DIR}
        ${EXHAUSTIVE_GC_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries(ch5-gcurves
        -lbtools-core
        -lbtools-reader
        -lbtools-utils
        -lscabolic-optimization
        -lscabolic-energy
        -lscabolic-core
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lexhaustive-gc-core
        -lexhaustive-gc-energy
        -lexhaustive-gc-api
        -lgcurve
        -lgcurve-utils
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})

install(TARGETS ch5-gcurves
        DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)