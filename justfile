version := `python -c "import tomllib; print(tomllib.load(open('pyproject.toml', 'rb'))['project']['version'])"`
name := `python -c "import tomllib; print(tomllib.load(open('pyproject.toml', 'rb'))['project']['name'])"`


default:
	@echo "\"just publish\"?"

tag:
	@if [ "$(git rev-parse --abbrev-ref HEAD)" != "main" ]; then exit 1; fi
	curl -H "Authorization: token `cat ~/.github-access-token`" -d '{"tag_name": "v{{version}}"}' https://api.github.com/repos/nschloe/{{name}}/releases

upload: clean
	@if [ "$(git rev-parse --abbrev-ref HEAD)" != "main" ]; then exit 1; fi
	# https://stackoverflow.com/a/58756491/353337
	python3 -m build --sdist --wheel .
	twine upload dist/*

publish: tag upload

clean:
	@find . | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf
	@rm -rf *.egg-info/ src/*.egg-info/ build/ dist/ .tox/ node_modules/

dep:
	npm install
	cp node_modules/bootstrap/dist/css/bootstrap.min.css tuna/web/static/
	cp node_modules/d3/dist/d3.min.js tuna/web/static/

update:
	npm update
	npm update --save-dev
	npm outdated

lint:
	pre-commit run --all

format:
	ruff check --fix tuna/ tests/
	black tuna/ tests/
	# blacken-docs README.md
	prettier --write README.md .github tuna/web/static/icicle.js tuna/web/static/tuna.css tuna/web/index.html
