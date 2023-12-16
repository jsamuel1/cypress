#!/bin/bash
# Build or load centos7-builder image
if [[ ! -f better_sqlite3.node ]]; then
	set -x
	docker build --ulimit nofile=65535:65535 -t centos7-builder -f centos7-builder.Dockerfile .
	docker run -d --name centos7-builder --ulimit nofile=65535:65535 centos7-builder /bin/bash -c "sleep 1000000000"
	docker cp ${PWD}/node_modules/better-sqlite3 centos7-builder:/better-sqlite3
	docker exec -it centos7-builder /bin/bash -c "cd /better-sqlite3 && source /root/.bashrc && chown -R root:root . && npm install --ignore-scripts && npx --no-install prebuild -r electron -t 25.0.0 --include-regex 'better_sqlite3.node$'"
	docker cp centos7-builder:/better-sqlite3/build/Release/better_sqlite3.node ${PWD}/node_modules/better-sqlite3/build/Release/better_sqlite3.node
	docker rm -f centos7-builder
	cp ${PWD}/node_modules/better-sqlite3/build/Release/better_sqlite3.node ${PWD}/better_sqlite3.node
else
	cp ${PWD}/better_sqlite3.node ${PWD}/node_modules/better-sqlite3/build/Release/better_sqlite3.node
fi
