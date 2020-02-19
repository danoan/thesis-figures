cmake_minimum_required(VERSION 3.2)
project(nochapter-digital-grid)

add_executable(nochapter-digital-grid nochapter-digital-grid.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(nochapter-digital-grid dipacus)
endif()

target_include_directories(nochapter-digital-grid PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(nochapter-digital-grid PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries(nochapter-digital-grid
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})