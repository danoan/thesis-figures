cmake_minimum_required(VERSION 3.2)
project(nochapter-graph-cut-evolution)

add_executable(nochapter-graph-cut-evolution nochapter-graph-cut-evolution.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(nochapter-graph-cut-evolution dipacus)
endif()

target_include_directories(nochapter-graph-cut-evolution PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${SCABOLIC_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(nochapter-graph-cut-evolution PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries(nochapter-graph-cut-evolution
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lscabolic-core
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})