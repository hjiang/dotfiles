# The default options for `stow` are specified in `.stowrc`

HOSTNAME := $(shell hostname 2>/dev/null || uname -n 2>/dev/null || echo "unknown")

ifeq (${HOSTNAME},unknown)
$(warning Could not determine hostname)
endif

.PHONY: install uninstall

install:
	stow shared
	stow ${HOSTNAME}

uninstall:
	stow -D ${HOSTNAME}
	stow -D shared
