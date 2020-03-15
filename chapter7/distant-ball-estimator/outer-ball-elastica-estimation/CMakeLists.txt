project(ch7-outer-ball-elastica-estimation)

add_executable(ch7-outer-ball-elastica-estimation ch7-outer-ball-elastica-estimation.cpp)

if( ${USE_REMOTE_REPOSITORIES} )
    add_dependencies(ch7-outer-ball-elastica-estimation dipacus scabolic)
endif()

target_link_directories(ch7-outer-ball-elastica-estimation PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${SCABOLIC_LIBS_DIR}
        ${DGTAL_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_include_directories(ch7-outer-ball-elastica-estimation PRIVATE
        ${DIPACUS_INCLUDE_DIRS}
        ${SCABOLIC_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_libraries(ch7-outer-ball-elastica-estimation
        -lscabolic-core
        -ldipacus-base
        -ldipacus-components
        -ldipacus-derivates
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES})
