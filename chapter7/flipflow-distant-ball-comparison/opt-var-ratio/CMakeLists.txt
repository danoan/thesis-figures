cmake_minimum_required(VERSION 3.2)
project(ch7-opt-var-ratio)

add_executable(ch7-opt-var-ratio ch7-opt-var-ratio.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(ch7-opt-var-ratio dipacus geoc)
endif()

target_include_directories(ch7-opt-var-ratio PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${SCABOLIC_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(ch7-opt-var-ratio PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries(ch7-opt-var-ratio
        -ldipacus-components
        -ldipacus-base
        -lscabolic-core
        -ldipacus-derivates
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})

install(TARGETS ch7-opt-var-ratio
        DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)