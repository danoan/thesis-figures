add_executable(ch5-mdca-sensitivity. ch5-mdca-sensitivity.cpp)

add_dependencies(ch5-mdca-sensitivity. dipacus gcurve)

target_include_directories(ch5-mdca-sensitivity. PRIVATE
        ${DIPACUS_INCLUDE_DIRS}
        ${GCURVE_INCLUDE_DIRS}
        ${BOOST_INCLUDE_DIRS}
        ${DGTAL_INCLUDE_DIRS})

target_link_directories(ch5-mdca-sensitivity. PRIVATE
        ${DIPACUS_LIBS_DIR}
        ${BOOST_LIBS_DIR})

target_link_libraries(ch5-mdca-sensitivity.
        -ldipacus-derivates
        -ldipacus-components
        -ldipacus-base
        -lgcurve
        -lgcurve-utils
        -lboost_filesystem
        -lboost_system
        ${DGTAL_LIBRARIES}
        ${OpenCV_LIBS})