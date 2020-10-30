cmake_minimum_required(VERSION 3.2)
project(slides-shapes)

add_executable(slides-shapes slides-shapes.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(slides-shapes dipacus)
endif()

target_include_directories(slides-shapes PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(slides-shapes PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries(slides-shapes
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})