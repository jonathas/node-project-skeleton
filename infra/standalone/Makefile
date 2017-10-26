define install_all
	@echo "========== Updating code =========="
	@echo
	-cd ../.. && git stash && git pull origin master
	@echo
	@echo "========== Installing dependencies =========="
	@echo
	cd ../../api && yarn install
	@echo
endef

define clean_all
	@echo "========== Cleaning the project =========="
	@echo
	-rm -R ../../api/bin ../../api/node_modules ../../api/coverage
	@echo
	@echo "========== Destroying infrastructure =========="
	docker-compose kill
	docker-compose rm -f
endef

install:
	$(call install_all)
	cd ../../api && ./node_modules/.bin/gulp
	@echo "========== Starting server =========="
	@echo
	-docker-compose up -d
	@echo

deploy:
	$(call install_all)
	cd ../../api/bin && cp .env .. && cd .. && ./node_modules/.bin/gulp
	@echo "========== Reloading the server =========="
	@echo
	docker exec skel pm2 reload all
	@echo

uninstall:
	$(call clean_all)
