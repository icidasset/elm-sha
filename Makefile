all: docs test


# Generate documentation
docs:
	elm make --docs=docs.json


# Run all the documentation tests using `elm-proofread`
test:
	@(cd src && \
		find . -name "*.elm" -print0 | \
		xargs -0 -n 1 sh -c 'elm-proofread -- $$0 || exit 255; echo "\n\n"' )
