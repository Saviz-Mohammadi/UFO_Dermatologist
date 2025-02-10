# [[ Project ]]
# [[ ----------------------------------------------------------------------- ]]
# [[ ----------------------------------------------------------------------- ]]

# Each internal library can act as a project. You can also just use a normal
# variable name for the same purpose if you wish to.

# Project name cannot contain any spaces. Use underlines instead.
project("Lib_NOTIFIER"

    VERSION 0.0.1

    DESCRIPTION "This library is in charge of handling the database behind
                 the UFO_Dermatologist application."

    LANGUAGES CXX)

# [[ ----------------------------------------------------------------------- ]]
# [[ ----------------------------------------------------------------------- ]]
# [[ Project ]]





# [[ Files ]]
# [[ ----------------------------------------------------------------------- ]]
# [[ ----------------------------------------------------------------------- ]]

set(HEADER_FILES

    "${CMAKE_CURRENT_SOURCE_DIR}/include/notifier.hpp")
	

set(SOURCE_FILES

    "${CMAKE_CURRENT_SOURCE_DIR}/src/notifier.cpp")

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
    Qt6::QuickControls2
    Qt6::Network
    Qt6::Sql)

# [[ ----------------------------------------------------------------------- ]]
# [[ ----------------------------------------------------------------------- ]]
# [[ Library ]]





# [[ Internal Library ]]
# [[ ----------------------------------------------------------------------- ]]
# [[ ----------------------------------------------------------------------- ]]

include(FetchContent)

# Fetch the SMTP client library
FetchContent_Declare(
    smtpclientlibrary
    GIT_REPOSITORY https://github.com/jeremydumais/CPP-SMTPClient-library.git
    GIT_TAG master
)

# Make the library available
FetchContent_MakeAvailable(smtpclientlibrary)

# Include the library's headers
include_directories(${smtpclientlibrary_SOURCE_DIR}/src)

# If you are on Windows, uncomment the following lines:
if(WIN32)
    include_directories($ENV{OPENSSL_INCLUDE_DIR})
    link_directories($ENV{OPENSSL_CRYPTO_LIBRARY})
endif()


target_link_libraries(${PROJECT_NAME}

    PRIVATE
    
    "Lib_Database"
    smtpclient)

# [[ ----------------------------------------------------------------------- ]]
# [[ ----------------------------------------------------------------------- ]]
# [[ Internal Library ]]
