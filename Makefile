# Makefile for Claude Marketplace Plugin Development

# Default installation directory
INSTALL_DIR ?= .

# Plugin name (use: make install PLUGIN=plugin-name)
PLUGIN ?=

.PHONY: install
install: ## Install plugin (including all agents, commands and skills)
	@if [ -z "$(PLUGIN)" ]; then \
		echo "Error: Please specify PLUGIN name"; \
		echo "Usage: make install PLUGIN=git"; \
		exit 1; \
	fi
	@if [ ! -d "plugins/$(PLUGIN)" ]; then \
		echo "Error: plugins/$(PLUGIN) directory not found"; \
		exit 1; \
	fi
	@echo "Installing plugin: $(PLUGIN)"
	@echo ""
	@# Install agents
	@if [ -d "plugins/$(PLUGIN)/agents" ]; then \
		echo "Installing Agents:"; \
		mkdir -p "$(INSTALL_DIR)/.claude/agents/test/$(PLUGIN)"; \
		for agent in plugins/$(PLUGIN)/agents/*/; do \
			if [ -d "$$agent" ]; then \
				agent_name=$$(basename "$$agent"); \
				target="$(INSTALL_DIR)/.claude/agents/test/$(PLUGIN)/$$agent_name"; \
				if [ -L "$$target" ]; then \
					rm "$$target"; \
				fi; \
				ln -s "$(PWD)/plugins/$(PLUGIN)/agents/$$agent_name" "$$target"; \
				echo "  ✓ $$agent_name"; \
			fi; \
		done; \
	fi
	@# Install commands
	@if [ -d "plugins/$(PLUGIN)/commands" ]; then \
		echo ""; \
		echo "Installing Commands:"; \
		mkdir -p "$(INSTALL_DIR)/.claude/commands/test/$(PLUGIN)"; \
		for cmd in plugins/$(PLUGIN)/commands/*.md; do \
			if [ -f "$$cmd" ]; then \
				cmd_name=$$(basename "$$cmd"); \
				target="$(INSTALL_DIR)/.claude/commands/test/$(PLUGIN)/$$cmd_name"; \
				if [ -L "$$target" ]; then \
					rm "$$target"; \
				fi; \
				ln -s "$(PWD)/plugins/$(PLUGIN)/commands/$$cmd_name" "$$target"; \
				echo "  ✓ $${cmd_name%.md}"; \
			fi; \
		done; \
	fi
	@# Install skills
	@if [ -d "plugins/$(PLUGIN)/skills" ]; then \
		echo ""; \
		echo "Installing Skills:"; \
		mkdir -p "$(INSTALL_DIR)/.claude/skills/test/$(PLUGIN)"; \
		for skill in plugins/$(PLUGIN)/skills/*/; do \
			if [ -d "$$skill" ]; then \
				skill_name=$$(basename "$$skill"); \
				target="$(INSTALL_DIR)/.claude/skills/test/$(PLUGIN)/$$skill_name"; \
				if [ -L "$$target" ]; then \
					rm "$$target"; \
				fi; \
				ln -s "$(PWD)/plugins/$(PLUGIN)/skills/$$skill_name" "$$target"; \
				echo "  ✓ $$skill_name"; \
			fi; \
		done; \
	fi
	@echo ""
	@echo "✓ Plugin $(PLUGIN) installed successfully"

.PHONY: uninstall
uninstall: ## Uninstall plugin (including all agents, commands and skills)
	@if [ -z "$(PLUGIN)" ]; then \
		echo "Error: Please specify PLUGIN name"; \
		echo "Usage: make uninstall PLUGIN=git"; \
		exit 1; \
	fi
	@echo "Uninstalling plugin: $(PLUGIN)"
	@removed=0; \
	if [ -d "$(INSTALL_DIR)/.claude/agents/test/$(PLUGIN)" ]; then \
		rm -rf "$(INSTALL_DIR)/.claude/agents/test/$(PLUGIN)"; \
		echo "  ✓ Removed agents"; \
		removed=1; \
	fi; \
	if [ -d "$(INSTALL_DIR)/.claude/commands/test/$(PLUGIN)" ]; then \
		rm -rf "$(INSTALL_DIR)/.claude/commands/test/$(PLUGIN)"; \
		echo "  ✓ Removed commands"; \
		removed=1; \
	fi; \
	if [ -d "$(INSTALL_DIR)/.claude/skills/test/$(PLUGIN)" ]; then \
		rm -rf "$(INSTALL_DIR)/.claude/skills/test/$(PLUGIN)"; \
		echo "  ✓ Removed skills"; \
		removed=1; \
	fi; \
	if [ $$removed -eq 0 ]; then \
		echo "Plugin not found: $(PLUGIN)"; \
	else \
		echo ""; \
		echo "✓ Plugin $(PLUGIN) uninstalled successfully"; \
	fi

.PHONY: list-plugins
list-plugins: ## List all available plugins
	@echo "Available Plugins:"
	@ls -1 plugins/ | grep -v '^\.' | sed 's/^/  - /'

.PHONY: list-installed
list-installed: ## List installed plugins in test directory
	@echo "Installed Agents:"
	@if [ -d "$(INSTALL_DIR)/.claude/agents/test" ]; then \
		for plugin_dir in $(INSTALL_DIR)/.claude/agents/test/*/; do \
			if [ -d "$$plugin_dir" ]; then \
				plugin_name=$$(basename "$$plugin_dir"); \
				echo "  $$plugin_name:"; \
				ls -1 "$$plugin_dir" | sed 's/^/    - /'; \
			fi; \
		done || echo "  (none)"; \
	else \
		echo "  (none)"; \
	fi
	@echo ""
	@echo "Installed Commands:"
	@if [ -d "$(INSTALL_DIR)/.claude/commands/test" ]; then \
		for plugin_dir in $(INSTALL_DIR)/.claude/commands/test/*/; do \
			if [ -d "$$plugin_dir" ]; then \
				plugin_name=$$(basename "$$plugin_dir"); \
				echo "  $$plugin_name:"; \
				ls -1 "$$plugin_dir" | sed 's/\.md$$//' | sed 's/^/    - /'; \
			fi; \
		done || echo "  (none)"; \
	else \
		echo "  (none)"; \
	fi
	@echo ""
	@echo "Installed Skills:"
	@if [ -d "$(INSTALL_DIR)/.claude/skills/test" ]; then \
		for plugin_dir in $(INSTALL_DIR)/.claude/skills/test/*/; do \
			if [ -d "$$plugin_dir" ]; then \
				plugin_name=$$(basename "$$plugin_dir"); \
				echo "  $$plugin_name:"; \
				ls -1 "$$plugin_dir" | sed 's/^/    - /'; \
			fi; \
		done || echo "  (none)"; \
	else \
		echo "  (none)"; \
	fi

.PHONY: clean-test
clean-test: ## Clean all test directory installations
	@echo "Cleaning test directories..."
	@rm -rf "$(INSTALL_DIR)/.claude/agents/test"
	@rm -rf "$(INSTALL_DIR)/.claude/commands/test"
	@rm -rf "$(INSTALL_DIR)/.claude/skills/test"
	@echo "✓ Cleaned successfully"
