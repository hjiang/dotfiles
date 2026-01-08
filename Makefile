# The default options for `stow` are specified in `.stowrc`

ORIGINAL_HOSTNAME := $(shell hostname -s 2>/dev/null || uname -n 2>/dev/null || echo "unknown")
HOSTNAME := $(shell echo $(ORIGINAL_HOSTNAME) | tr '[:upper:]' '[:lower:]')

ifeq (${HOSTNAME},unknown)
$(warning Could not determine hostname)
endif

.PHONY: default install uninstall download-assets rose-pine-hyprcursor wallpaper-house

default: install

download-assets: rose-pine-hyprcursor wallpaper-house

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

wallpaper-house:
	@if [ -f "$(HOME)/.local/share/backgrounds/a_house_with_a_chair_and_a_bicycle.jpg" ]; then \
		echo "wallpaper-house already exists, skipping download"; \
	else \
		echo "Downloading wallpaper..."; \
		mkdir -p $(HOME)/.local/share/backgrounds; \
		curl -L https://raw.githubusercontent.com/dharmx/walls/6bf4d733ebf2b484a37c17d742eb47e5139e6a14/radium/a_house_with_a_chair_and_a_bicycle.jpg \
		-o $(HOME)/.local/share/backgrounds/a_house_with_a_chair_and_a_bicycle.jpg; \
		echo "Done!"; \
	fi

install:
	stow --restow shared
	stow --restow ${HOSTNAME}

uninstall:
	stow -D ${HOSTNAME}
	stow -D shared
