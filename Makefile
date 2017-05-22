NODE_MODULES=node_modules
NODE_MODULES_BIN=node_modules/.bin
WEBPACK_BIN=$(NODE_MODULES_BIN)/webpack
MOCHA_BIN=$(NODE_MODULES_BIN)/mocha
NYC_BIN=$(NODE_MODULES_BIN)/nyc
NODE_TESTS=assets/main.js

all: install

install-yarn: package.json
	yarn install

install: install-yarn

build: install
	$(WEBPACK_BIN) $(WEBPACKARGS)

watch: WEBPACKARGS=--watch
watch: build

clean:
	git clean -dx -e .env

clean-dry:
	git clean -n -dx -e .env

SESSION=testing
session_exists = $(shell tmux has-session -t "$(SESSION)" 2>/dev/null; echo $$?)
dev-session:
ifneq ($(session_exists),0)
	# Only create session if not already exists
	tmux new-session -s "$(SESSION)" -n editor -d
	tmux split-window -v

	# Watch node
	tmux select-pane -t0
	tmux resize-pane -y10
	tmux send-keys -t "$(SESSION)" "make watch" C-m

	# Main shell
	tmux select-pane -t1
endif

dev: install dev-session
	# Attach to existing or created session
	tmux attach -t "$(SESSION)"

test:
	$(MOCHA_BIN) --compilers js:babel-core/register $(NODE_TESTS)

coverage:
	$(NYC_BIN) --require babel-core/register make test

.PHONY: test clean coverage
