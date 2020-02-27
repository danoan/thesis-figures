project(ch7-labeling-comparison)

add_executable(ch7-labeling-comparison ch7-labeling-comparison.cpp
        src/DGCIEnergy.cpp)

if( ${USE_REMOTE_REPOSITORIES} )
    add_dependencies(ch7-labeling-comparison dipacus scabolic)
endif()

target_link_directories(ch7-labeling-comparison PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${SCABOLIC_LIBS_DIR}
        ${DGTAL_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_include_directories(ch7-labeling-comparison PRIVATE
        include
        ${DIPACUS_INCLUDE_DIRS}
        ${SCABOLIC_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_libraries(ch7-labeling-comparison
        -ldipacus-base
        -ldipacus-components
        -ldipacus-derivates
        -lscabolic-core
        -lscabolic-energy
        -lscabolic-optimization
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES})
