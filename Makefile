SHELL=/bin/bash -euo pipefail

install-python:
	poetry install

.git/hooks/pre-commit:
	cp scripts/pre-commit .git/hooks/pre-commit

install: install-python .git/hooks/pre-commit

lint:
	find . -name '*.py' -not -path '**/.venv/*' | xargs poetry run flake8

clean:
	rm -rf build
	rm -rf dist

publish: clean
	mkdir -p build

check-licenses:
	scripts/check_python_licenses.sh

format:
	poetry run black **/*.py


build-proxy:
	scripts/build_proxy.sh

_dist_include="poetry.lock poetry.toml pyproject.toml Makefile build/."

release: clean publish build-proxy
	mkdir -p dist
	for f in $(_dist_include); do cp -r $$f dist; done
