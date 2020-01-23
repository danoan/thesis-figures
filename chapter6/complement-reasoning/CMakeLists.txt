cmake_minimum_required(VERSION 3.2)
project(ch6-complement-reasoning)

find_package(DGtal REQUIRED)
find_package(OpenCV REQUIRED)

add_executable(ch6-complement-reasoning ch6-complement-reasoning.cpp)

if(${USE_REMOTE_REPOSITORIES})
    add_dependencies(ch6-complement-reasoning dipacus-jmiv scabolic-jmiv)
endif()


target_link_directories(ch6-complement-reasoning PRIVATE
        ${JMIV_DIPACUS_LIBS_DIR}
        ${JMIV_SCABOLIC_LIBS_DIR}
        ${CMAKE_PREFIX_PATH}
        ${BOOST_LIBS_DIR})

target_include_directories(ch6-complement-reasoning PRIVATE
        include
        ${JMIV_DIPACUS_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS}
        ${BOOST_INCLUDE_DIRS})

target_link_libraries(ch6-complement-reasoning
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lscabolic-core
        -lscabolic-energy
        -lscabolic-optimization
        -lboost_system
        -lboost_filesystem
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})