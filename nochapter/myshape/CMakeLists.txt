cmake_minimum_required(VERSION 3.2)
project(nochapter-myshape)

add_executable(nochapter-myshape nochapter-myshape.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(nochapter-myshape dipacus)
endif()

target_include_directories(nochapter-myshape PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(nochapter-myshape PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries(nochapter-myshape
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})