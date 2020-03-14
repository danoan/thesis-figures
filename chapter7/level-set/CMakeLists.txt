cmake_minimum_required(VERSION 3.2)
project(ch7-level-set)

add_executable(ch7-level-set
        ch7-level-set.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(ch7-level-set dipacus geoc)
endif()

target_include_directories(ch7-level-set PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${SCABOLIC_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(ch7-level-set PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries(ch7-level-set
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})

install(TARGETS ch7-level-set
        DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)