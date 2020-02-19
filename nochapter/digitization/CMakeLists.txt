cmake_minimum_required(VERSION 3.2)
project(nochapter-digitization)

add_executable(nochapter-digitization nochapter-digitization.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(nochapter-digitization dipacus)
endif()

target_include_directories(nochapter-digitization PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(nochapter-digitization PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries(nochapter-digitization
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})