cmake_minimum_required(VERSION 3.2)
project(ch7-shape-potential-evolution)

add_executable(ch7-shape-potential-evolution ch7-shape-potential-evolution.cpp
        src/Flow.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(ch7-shape-potential-evolution dipacus scabolic geoc)
endif()

target_include_directories(ch7-shape-potential-evolution PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${SCABOLIC_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(ch7-shape-potential-evolution PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${SCABOLIC_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries(ch7-shape-potential-evolution
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

install(TARGETS ch7-shape-potential-evolution
        DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)