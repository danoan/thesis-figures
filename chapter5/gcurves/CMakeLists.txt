add_executable(ch5-gcurves ch5-gcurves.cpp)

add_dependencies(ch5-gcurves scabolic dipacus exhaustive-gc gcurve)

target_include_directories(ch5-gcurves PRIVATE
        include
        ${BOOST_INCLUDE_DIRS}
        ${DIPACUS_INCLUDE_DIRS}
        ${SCABOLIC_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(ch5-gcurves PRIVATE
        ${BOOST_LIBS_DIR}
        ${DIPACUS_LIBS_DIR}
        ${SCABOLIC_LIBS_DIR}
        ${EXHAUSTIVE_GC_LIBS_DIR}
        ${GCURVE_LIBS_DIR})

target_link_libraries(ch5-gcurves
        -lscabolic-optimization
        -lscabolic-energy
        -lscabolic-core
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lexhaustive-gc-api
        -lexhaustive-gc-core
        -lexhaustive-gc-energy
        -lgcurve
        -lgcurve-utils
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})

install(TARGETS ch5-gcurves
        DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)