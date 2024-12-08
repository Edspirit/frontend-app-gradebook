npm-install-%: ## install specified % npm package
	npm ci $* --save-dev
	git add package.json

intl_imports = ./node_modules/.bin/intl-imports.js
transifex_utils = ./node_modules/.bin/transifex-utils.js
i18n = ./src/i18n
transifex_input = $(i18n)/transifex_input.json

# This directory must match .babelrc .
transifex_temp = ./temp/babel-plugin-formatjs

NPM_TESTS=build i18n_extract lint test is-es5

.PHONY: test
test: $(addprefix test.npm.,$(NPM_TESTS))  ## validate ci suite

.PHONY: test.npm.*
test.npm.%: validate-no-uncommitted-package-lock-changes
	test -d node_modules || $(MAKE) requirements
	npm run $(*)

.PHONY: requirements
requirements:  ## install ci requirements
	npm ci

i18n.extract:
	# Pulling display strings from .jsx files into .json files...
	rm -rf $(transifex_temp)
	npm run-script i18n_extract

i18n.concat:
	# Gathering JSON messages into one file...
	$(transifex_utils) $(transifex_temp) $(transifex_input)

extract_translations: | requirements i18n.extract i18n.concat


# Experimental: OEP-58 Pulls translations using atlas
pull_translations:
	rm -rf src/i18n/messages
	mkdir src/i18n/messages
	cd src/i18n/messages \
	  && atlas pull $(ATLAS_OPTIONS) \
	           translations/frontend-component-footer/src/i18n/messages:frontend-component-footer \
	           translations/frontend-component-header/src/i18n/messages:frontend-component-header \
	           translations/frontend-platform/src/i18n/messages:frontend-platform \
	           translations/paragon/src/i18n/messages:paragon \
	           translations/frontend-app-gradebook/src/i18n/messages:frontend-app-gradebook

	# Create fa_IR.json duplicates from fa.json
	for dir in src/i18n/messages/*; do \
		if [ -f "$$dir/fa.json" ]; then \
			cp "$$dir/fa.json" "$$dir/fa_IR.json"; \
		fi \
	done

	# Update index.js files to include fa_IR
	for index_file in src/i18n/messages/*/index.js; do \
		if [ -f "$${index_file%/*}/fa_IR.json" ]; then \
			sed -i '/import messagesOfFaLanguage/a import messagesOfFaIrLanguage from '\''./fa_IR.json'\'';' "$$index_file"; \
			sed -i "/'fa': messagesOfFaLanguage,/a\ \ 'fa-ir': messagesOfFaIrLanguage," "$$index_file"; \
		fi \
	done

	# Clone repos to temp directory and copy i18n files
	rm -rf temp/header-repo temp/footer-repo
	mkdir -p temp
	git clone --depth 1 https://github.com/edSPIRIT/frontend-component-header.git temp/header-repo && cd temp/header-repo && git fetch --depth 1 origin tag v5.7.4 && git checkout v5.7.4 && cd ../../
	git clone --depth 1 https://github.com/edSPIRIT/frontend-component-footer.git temp/footer-repo && cd temp/footer-repo && git fetch --depth 1 origin tag v14.0.12 && git checkout v14.0.12 && cd ../../
	
	# Copy header translations and i18n files
	mkdir -p src/i18n/messages/frontend-component-header
	cp temp/header-repo/src/i18n/messages/*.json src/i18n/messages/frontend-component-header/
	cp temp/header-repo/src/i18n/index.js src/i18n/messages/frontend-component-header/
	
	# Copy footer translations
	mkdir -p src/i18n/messages/frontend-component-footer
	cp temp/footer-repo/src/i18n/messages/*.json src/i18n/messages/frontend-component-footer/
	cp temp/footer-repo/src/i18n/index.js src/i18n/messages/frontend-component-footer/
	

	
	# Cleanup temp directories
	rm -rf temp/header-repo temp/footer-repo
	
	$(intl_imports) frontend-platform paragon frontend-component-header frontend-component-footer frontend-app-gradebook

# This target is used by CI.
validate-no-uncommitted-package-lock-changes:
	# Checking for package-lock.json changes...
	git diff --exit-code package-lock.json
