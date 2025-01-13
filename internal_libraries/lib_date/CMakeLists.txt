# [[ Project ]]
# [[ ----------------------------------------------------------------------- ]]
# [[ ----------------------------------------------------------------------- ]]

# Each internal library can act as a project. You can also just use a normal
# variable name for the same purpose if you wish to.

# Project name cannot contain any spaces. Use underlines instead.
project("Lib_Date"

    VERSION 0.0.1

    DESCRIPTION "This library is in charge of providing useful date management functions."

    LANGUAGES CXX)

# [[ ----------------------------------------------------------------------- ]]
# [[ ----------------------------------------------------------------------- ]]
# [[ Project ]]





# [[ Files ]]
# [[ ----------------------------------------------------------------------- ]]
# [[ ----------------------------------------------------------------------- ]]

set(HEADER_FILES

    "${CMAKE_CURRENT_SOURCE_DIR}/include/date.hpp")
	

set(SOURCE_FILES

    "${CMAKE_CURRENT_SOURCE_DIR}/src/date.cpp")

# [[ ----------------------------------------------------------------------- ]]
# [[ ----------------------------------------------------------------------- ]]
# [[ Files ]]





# [[ Library ]]
# [[ ----------------------------------------------------------------------- ]]
# [[ ----------------------------------------------------------------------- ]]

qt_add_library(${PROJECT_NAME} STATIC)




target_sources(${PROJECT_NAME}

    PUBLIC
    ${HEADER_FILES}

    PRIVATE
    ${SOURCE_FILES})




target_include_directories(${PROJECT_NAME}
	
    PUBLIC

    "${CMAKE_CURRENT_SOURCE_DIR}/include")




target_link_libraries(${PROJECT_NAME}

    PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::QuickControls2)

# [[ ----------------------------------------------------------------------- ]]
# [[ ----------------------------------------------------------------------- ]]
# [[ Library ]]





# [[ Internal Library ]]
# [[ ----------------------------------------------------------------------- ]]
# [[ ----------------------------------------------------------------------- ]]

# Add any other internal libraries that this internal library may depend on.

target_link_libraries(${PROJECT_NAME}

    PRIVATE
    "Lib_Logger")

# [[ ----------------------------------------------------------------------- ]]
# [[ ----------------------------------------------------------------------- ]]
# [[ Internal Library ]]
