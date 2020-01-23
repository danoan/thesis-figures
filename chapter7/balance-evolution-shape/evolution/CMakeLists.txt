cmake_minimum_required(VERSION 3.2)
project(ch7-balance-evolution-shape)

add_executable(ch7-balance-evolution-shape ch7-balance-evolution-shape.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(ch7-balance-evolution-shape dipacus geoc)
endif()

target_include_directories(ch7-balance-evolution-shape PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${SCABOLIC_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(ch7-balance-evolution-shape PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries(ch7-balance-evolution-shape
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})

install(TARGETS ch7-balance-evolution-shape
        DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)