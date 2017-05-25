

uname_o:=$(shell uname -o)
uname_m:=$(shell uname -m)

ifeq (Cygwin,$(uname_o))
IS_WIN:=true

define NATIVE_PATH
$(shell cygpath -w $(1) | sed -e 's%\\%/%g')
endef

PARENT_DIR_A=$(shell cd .. ; cygpath -w `pwd` | sed -e 's%\\%/%g')
else
IS_WIN:=false
define NATIVE_PATH
$1
endef

PARENT_DIR_A=$(shell cd .. ; pwd)
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