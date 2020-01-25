set(JMIV_DIPACUS_INCLUDE_DIRS ${EXTPROJECTS_BUILD_DIR}/jmiv/include CACHE PATH "DIPaCUS include location path.")
set(JMIV_DIPACUS_LIBS_DIR ${EXTPROJECTS_BUILD_DIR}/jmiv/lib CACHE PATH "DIPaCUS libraries location path.")

set(JMIV_SCABOLIC_INCLUDE_DIRS ${EXTPROJECTS_BUILD_DIR}/jmiv/include CACHE PATH "SCaBOliC include location path.")
set(JMIV_SCABOLIC_LIBS_DIR ${EXTPROJECTS_BUILD_DIR}/jmiv/lib CACHE PATH "SCaBOliC libraries location path.")

set(JMIV_EXHAUSTIVE_GC_INCLUDE_DIRS ${EXTPROJECTS_BUILD_DIR}/jmiv/include CACHE PATH "Exhaustive-gc include location path.")
set(JMIV_EXHAUSTIVE_GC_LIBS_DIR ${EXTPROJECTS_BUILD_DIR}/jmiv/lib CACHE PATH "Exhaustive-gc libraries location path.")

set(JMIV_BTOOLS_INCLUDE_DIRS ${EXTPROJECTS_BUILD_DIR}/jmiv/include CACHE PATH "BTools include location path.")
set(JMIV_BTOOLS_LIBS_DIR ${EXTPROJECTS_BUILD_DIR}/jmiv/lib CACHE PATH "BTools libraries location path.")

set(JMIV_GCURVE_INCLUDE_DIRS ${EXTPROJECTS_BUILD_DIR}/jmiv/include CACHE PATH "GCurve include location path.")
set(JMIV_GCURVE_LIBS_DIR ${EXTPROJECTS_BUILD_DIR}/jmiv/lib CACHE PATH "GCurve libraries location path.")

set(JMIV_GEOC_INCLUDE_DIRS ${EXTPROJECTS_BUILD_DIR}/jmiv/include CACHE PATH "GEOC include location path.")
set(JMIV_GEOC_LIBS_DIR ${EXTPROJECTS_BUILD_DIR}/jmiv/lib CACHE PATH "GEOC libraries location path.")

set(JMIV_MAGLAC_INCLUDE_DIRS ${EXTPROJECTS_BUILD_DIR}/jmiv/include CACHE PATH "MagLac include location path.")
set(JMIV_MAGLAC_LIBS_DIR ${EXTPROJECTS_BUILD_DIR}/jmiv/lib CACHE PATH "MagLac libraries location path.")

add_subdirectory(complement-reasoning)
add_subdirectory(topology-change)
add_subdirectory(unlabeled-ratio)