cmake_minimum_required(VERSION 3.2)
project(ch7-around-normal-evolution)

add_executable(ch7-around-normal-evolution ch7-around-normal-evolution.cpp
        energy.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(ch7-around-normal-evolution dipacus scabolic geoc)
endif()

target_include_directories(ch7-around-normal-evolution PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${SCABOLIC_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(ch7-around-normal-evolution PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${SCABOLIC_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries(ch7-around-normal-evolution
        -lscabolic-core
        -lscabolic-energy
        -lscabolic-optimization
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})

install(TARGETS ch7-around-normal-evolution
        DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)