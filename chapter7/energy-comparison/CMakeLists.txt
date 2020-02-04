project(ch7-energy-comparison)

add_executable(ch7-energy-comparison ch7-energy-comparison.cpp)

if( ${USE_REMOTE_REPOSITORIES} )
    add_dependencies(ch7-energy-comparison dipacus scabolic)
endif()

target_link_directories(ch7-energy-comparison PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${SCABOLIC_LIBS_DIR}
        ${DGTAL_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_include_directories(ch7-energy-comparison PRIVATE
        ${DIPACUS_INCLUDE_DIRS}
        ${SCABOLIC_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_libraries(ch7-energy-comparison
        -ldipacus-base
        -ldipacus-components
        -ldipacus-derivates
        -lscabolic-core
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES})
