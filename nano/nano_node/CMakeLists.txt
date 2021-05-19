add_executable (btco_node
	daemon.cpp
	daemon.hpp
	entry.cpp)

target_link_libraries (btco_node
	node
	rpc
	secure
	argon2
	Boost::boost
	${PLATFORM_LIBS}
)

if (NANO_STACKTRACE_BACKTRACE)
	target_link_libraries(btco_node backtrace)
endif ()

target_compile_definitions(btco_node
	PRIVATE
		-DTAG_VERSION_STRING=${TAG_VERSION_STRING}
		-DGIT_COMMIT_HASH=${GIT_COMMIT_HASH}
		-DBOOST_PROCESS_SUPPORTED=${BOOST_PROCESS_SUPPORTED})

set_target_properties (btco_node
	PROPERTIES
		COMPILE_FLAGS
			"-DQT_NO_KEYWORDS -DBOOST_ASIO_HAS_STD_ARRAY=1")

add_custom_command(TARGET btco_node
				   POST_BUILD
				   COMMAND btco_node --generate_config node > ${PROJECT_BINARY_DIR}/config-node.toml.sample
				   COMMAND btco_node --generate_config rpc > ${PROJECT_BINARY_DIR}/config-rpc.toml.sample)

if ((NANO_GUI OR RAIBLOCKS_GUI) AND NOT APPLE)
	if (WIN32)
		install(TARGETS btco_node
				RUNTIME DESTINATION .
		)
	else ()
		install(TARGETS btco_node
				RUNTIME DESTINATION ./bin)
	endif()
endif()
