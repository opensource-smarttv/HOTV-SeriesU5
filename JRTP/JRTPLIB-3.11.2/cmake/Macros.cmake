macro(jrtplib_support_option DESCRIPTION OPTIONNAME DEFINENAME DEFAULTVALUE EMPTYVALUE)
	option(${OPTIONNAME} ${DESCRIPTION} ${DEFAULTVALUE})
	if (${OPTIONNAME})
		set(${DEFINENAME} "#define ${DEFINENAME}")
	else (${OPTIONNAME})
		set(${DEFINENAME} "${EMPTYVALUE}")
	endif (${OPTIONNAME})
endmacro(jrtplib_support_option)

macro(jrtplib_include_test INCFILE DEFINENAME EMPTYVALUE)
	check_include_file_cxx(${INCFILE} jrtplib_include_test_${DEFINENAME})
	if (jrtplib_include_test_${DEFINENAME})
		set(${DEFINENAME} "#define ${DEFINENAME}")
	else (jrtplib_include_test_${DEFINENAME})
		set(${DEFINENAME} "${EMPTYVALUE}")
	endif (jrtplib_include_test_${DEFINENAME})
endmacro(jrtplib_include_test)

macro (jrtplib_test_feature FILENAME DEFINENAME INVERT EMPTYVALUE EXTRADEFS) 
	if (NOT DEFINED ${FILENAME}_RESULT)
		try_compile(${FILENAME}_RESULT "${PROJECT_BINARY_DIR}" "${PROJECT_SOURCE_DIR}/tools/${FILENAME}.cpp"
		            OUTPUT_VARIABLE OUTVAR 
			    COMPILE_DEFINITIONS "${EXTRADEFS}")
		message(STATUS "Compiling ${FILENAME}.cpp")
		set(BLA ${INVERT})
		if (NOT BLA)
			if (${FILENAME}_RESULT)
				set(${DEFINENAME} "#define ${DEFINENAME}" CACHE INTERNAL "setting ${DEFINENAME} in rtpconfig.h")
				message(STATUS "Compiling ${FILENAME}.cpp worked - setting ${DEFINENAME} in rtpconfig.h")
			else (${FILENAME}_RESULT)
				set(${DEFINENAME} "${EMPTYVALUE}" CACHE INTERNAL "")
				message(STATUS "Compiling ${FILENAME}.cpp failed - no action necessary")
			endif (${FILENAME}_RESULT)
		else (NOT BLA)
			if (NOT ${FILENAME}_RESULT)
				set(${DEFINENAME} "#define ${DEFINENAME}" CACHE INTERNAL "setting ${DEFINENAME} in rtpconfig.h")
				message(STATUS "Compiling ${FILENAME}.cpp failed - setting ${DEFINENAME} in rtpconfig.h")
			else (NOT ${FILENAME}_RESULT)
				set(${DEFINENAME} "${EMPTYVALUE}" CACHE INTERNAL "")
				message(STATUS "Compiling ${FILENAME}.cpp worked - no action necessary")
			endif (NOT ${FILENAME}_RESULT)
		endif (NOT BLA)
	endif (NOT DEFINED ${FILENAME}_RESULT)
endmacro (jrtplib_test_feature)

macro(save_paths VARNAME)
	set (BLA "${ARGN}")
	foreach(i IN LISTS BLA)
		set (BLA2 "${i}")
		if (BLA2)
			list(APPEND ${VARNAME} "${i}")
		endif (BLA2)
	endforeach(i)
	list(LENGTH ${VARNAME} BLA)
	if (BLA GREATER 0)
		list(REMOVE_DUPLICATES ${VARNAME})
	endif (BLA GREATER 0)
endmacro(save_paths)

macro(remove_empty VARNAME)
	set (remove_empty_NEWLIST "")
	foreach(i IN LISTS ${VARNAME})
		set (BLA2 "${i}")
		if (BLA2)
			list(APPEND remove_empty_NEWLIST "${i}")
		endif (BLA2)
	endforeach(i)
	set(${VARNAME} "${remove_empty_NEWLIST}")
endmacro(remove_empty)

macro(apply_include_paths VARNAME)
	set (BLA "${VARNAME}")
	foreach(i IN LISTS BLA)
		set (BLA2 "${i}")
		if (BLA2)
			include_directories("${i}")
		endif (BLA2)
	endforeach(i)
endmacro(apply_include_paths)

macro(add_additional_stuff INCVAR LIBVAR)
	set(ADDITIONAL_INCLUDE_DIRS "" CACHE STRING "Additional include directories")
	if (UNIX AND NOT WIN32)
		set(ADDITIONAL_LIBRARIES "" CACHE STRING "Additional libraries to link against")
	else (UNIX AND NOT WIN32)
		set(ADDITIONAL_GENERAL_LIBRARIES "" CACHE STRING "Additional libraries to link against in both debug and release modes")
		set(ADDITIONAL_RELEASE_LIBRARIES "" CACHE STRING "Additional libraries to link against in release mode")
		set(ADDITIONAL_DEBUG_LIBRARIES "" CACHE STRING "Additional libraries to link against in debug mode")

		set(ADDITIONAL_LIBRARIES "${ADDITIONAL_GENERAL_LIBRARIES}")

		foreach(l IN LISTS ADDITIONAL_RELEASE_LIBRARIES)
			list(APPEND ADDITIONAL_LIBRARIES optimized)
			list(APPEND ADDITIONAL_LIBRARIES "${l}")
		endforeach(l)
		foreach(l IN LISTS ADDITIONAL_DEBUG_LIBRARIES)
			list(APPEND ADDITIONAL_LIBRARIES debug)
			list(APPEND ADDITIONAL_LIBRARIES "${l}")
		endforeach(l)
	endif (UNIX AND NOT WIN32)

	save_paths(${INCVAR} "${ADDITIONAL_INCLUDE_DIRS}")
	save_paths(${LIBVAR} "${ADDITIONAL_LIBRARIES}")
endmacro(add_additional_stuff)

