# The default options for `stow` are specified in `.stowrc`

HOSTNAME := $(shell hostname 2>/dev/null || uname -n 2>/dev/null || echo "unknown")

ifeq (${HOSTNAME},unknown)
$(warning Could not determine hostname)
endif

.PHONY: install uninstall download-assets rose-pine-hyprcursor

download-assets: rose-pine-hyprcursor

rose-pine-hyprcursor:
	@if [ -d "$(HOME)/.local/share/icons/rose-pine-hyprcursor" ]; then \
		echo "rose-pine-hyprcursor already exists, skipping download"; \
	else \
		echo "Downloading rose-pine-hyprcursor theme..."; \
		mkdir -p $(HOME)/.local/share/icons/rose-pine-hyprcursor; \
		curl -L https://github.com/ndom91/rose-pine-hyprcursor/releases/download/v0.3.2/rose-pine-cursor-hyprcursor_0.3.2.tar.gz | \
		tar xz -C $(HOME)/.local/share/icons/rose-pine-hyprcursor; \
		echo "Done!"; \
	fi

install:
	stow shared
	stow ${HOSTNAME}

uninstall:
	stow -D ${HOSTNAME}
	stow -D shared
