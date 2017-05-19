NODE_MODULES=node_modules
WEBPACK_BIN=$(NODE_MODULES)/webpack/bin/webpack.js
MOCHA_BIN=$(NODE_MODULES)/mocha/bin/mocha
NODE_TESTS=test/node/*.js

all: install

install-yarn: package.json
	yarn install

install: install-yarn

build-node: install
	TARGET=node $(WEBPACK_BIN) $(WEBPACKARGS)

build-client: install
	TARGET=client $(WEBPACK_BIN) $(WEBPACKARGS)

build: build-node
build: build-client

watch-node: WEBPACKARGS=--watch
watch-node: build-node

watch-client: WEBPACKARGS=--watch
watch-client: build-client

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
	tmux send-keys -t "$(SESSION)" "make watch-node" C-m

	# Watch client
	tmux split-window -h
	tmux send-keys -t "$(SESSION)" "make watch-client" C-m

	# Main shell
	tmux select-pane -t2
endif

dev: install dev-session
	# Attach to existing or created session
	tmux attach -t "$(SESSION)"

test: $(NODE_TESTS)
	$(MOCHA_BIN) "$(NODE_TESTS)"
