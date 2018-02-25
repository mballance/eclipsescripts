
ifneq (true,$(VERBOSE))
Q=@
endif

ifneq (true,$(VERBOSE))
UNZIP:=unzip -o -qq
UNTAR_GZ:=tar xzf
UNTAR_BZ2:=tar xjf
else # Verbose
UNZIP:=unzip -o
UNTAR_GZ:=tar xvzf
UNTAR_BZ2:=tar xvhf
endif

uname_o:=$(shell uname -o)
uname_m:=$(shell uname -m)

ifeq (Cygwin,$(uname_o))
IS_WIN:=true

define NATIVE_PATH
$(shell cygpath -w $(1) | sed -e 's%\\%/%g')
endef

PARENT_DIR_A=$(shell cd .. ; cygpath -w `pwd` | sed -e 's%\\%/%g')
else
  ifeq (Msys,$(uname_o))
    IS_WIN:=true
    define NATIVE_PATH
$(shell echo $(1) | sed -e 's%^/\([a-zA-Z]\)%\1:%')
    endef
    PARENT_DIR_A=$(shell cd .. ; pwd | sed -e 's%^/\([a-zA-Z]\)%\1:%')
  else
    IS_WIN:=false
    define NATIVE_PATH
$1
    endef

    PARENT_DIR_A=$(shell cd .. ; pwd)
  endif
endif


ifeq (true,$(IS_WIN))
osgi_os:=win32
osgi_ws:=win32
else
osgi_os:=linux
osgi_ws:=gtk
endif

ifeq (x86_64,$(uname_m))
osgi_arch:=x86_64
else
osgi_arch:=x86
endif
