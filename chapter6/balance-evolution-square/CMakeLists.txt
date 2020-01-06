cmake_minimum_required(VERSION 3.2)
project(ch6-balance-evolution-square)

add_executable(ch6-balance-evolution-square ch6-balance-evolution-square.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(ch6-balance-evolution-square dipacus geoc)
endif()

target_include_directories(ch6-balance-evolution-square PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${SCABOLIC_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(ch6-balance-evolution-square PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries(ch6-balance-evolution-square
        -ldipacus-components
        -ldipacus-base
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})

install(TARGETS ch6-balance-evolution-square
        DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)