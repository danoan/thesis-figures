cmake_minimum_required(VERSION 3.2)
project(ch6-balance-evolution-maxDiff)

add_executable(ch6-balance-evolution-maxDiff ch6-balance-evolution-maxDiff.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(ch6-balance-evolution-maxDiff dipacus geoc magLac)
endif()

target_include_directories(ch6-balance-evolution-maxDiff PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${SCABOLIC_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(ch6-balance-evolution-maxDiff PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries(ch6-balance-evolution-maxDiff
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lboost_filesystem
        -lboost_system
        -lpthread
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})

install(TARGETS ch6-balance-evolution-maxDiff
        DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)