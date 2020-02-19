cmake_minimum_required(VERSION 3.2)
project(nochapter-standard-line)

add_executable(nochapter-standard-line nochapter-standard-line.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(nochapter-standard-line dipacus)
endif()

target_include_directories(nochapter-standard-line PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(nochapter-standard-line PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries(nochapter-standard-line
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})