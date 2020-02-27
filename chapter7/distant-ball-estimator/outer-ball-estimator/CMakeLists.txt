project(ch7-outer-ball-estimator)

add_executable(ch7-outer-ball-estimator ch7-outer-ball-estimator.cpp)

if( ${USE_REMOTE_REPOSITORIES} )
    add_dependencies(ch7-outer-ball-estimator dipacus)
endif()

target_link_directories(ch7-outer-ball-estimator PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${DGTAL_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_include_directories(ch7-outer-ball-estimator PRIVATE
        ${DIPACUS_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_libraries(ch7-outer-ball-estimator
        -ldipacus-base
        -ldipacus-components
        -ldipacus-derivates
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES})
