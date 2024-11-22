# Variables
SRC_DIR=frontend/src
DIST_DIR=frontend/dist
HOST_PORT=3000

# Default target: Compile and serve
all: build serve

# Compile TypeScript into JavaScript
build:
	npx tsc

# Start the local server
serve:
	npx serve -p $(HOST_PORT) frontend


clean:
	rm -rf $(DIST_DIR)

# Rebuild the project (clean and compile)
rebuild: clean build
