generate:
	tuist fetch
	tuist generate

clean:
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

reset:
	tuist clean
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

regenerate:
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace
	tuist generate
	
# Privates 파일 다운로드

BASE_URL=https://raw.githubusercontent.com/sopt-makers/SOPT-iOS-Private/main

XCCONFIG_PATHS = \
    xcconfigs/Base Common.xcconfig \
    xcconfigs/Base/Projects Project-Development.xcconfig \
    xcconfigs/Base/Projects Project-PROD.xcconfig \
    xcconfigs/Base/Projects Project-QA.xcconfig \
    xcconfigs/Base/Projects Project-Test.xcconfig \
    xcconfigs/Base/Projects Shared.xcconfig \
    xcconfigs/Base/Targets Application.xcconfig \
    xcconfigs/Base/Targets Extension.xcconfig \
    xcconfigs/Base/Targets Framework.xcconfig \
    xcconfigs/Base/Targets StaticLibrary.xcconfig \
    xcconfigs/targets iOS-Demo.xcconfig \
    xcconfigs/targets iOS-Framework.xcconfig \
    xcconfigs/targets iOS-StaticFramework.xcconfig \
    xcconfigs/targets iOS-Tests.xcconfig
    
define download_file
	mkdir -p $(1)
	curl -H "Authorization: token $(2)" -o $(1)/$(3) $(BASE_URL)/$(1)/$(3)
endef

download-privates:

	# Get GitHub Access Token
	@if [ ! -f .env ]; then \
		if [ -z "$$token" ]; then \
			read -p "Enter your GitHub access token: " token; \
		fi; \
		echo "GITHUB_ACCESS_TOKEN=$$token" > .env; \
	else \
		/bin/bash -c "source .env; make _download-privates"; \
		exit 0; \
	fi
	
	make _download-privates

_download-privates:
	
	$(eval export $(shell cat .env))
	
	# fastlane .env

	$(call download_file,fastlane,$$GITHUB_ACCESS_TOKEN,.env)
	
	# Config.swift
	
	$(call download_file,Projects/Modules/Network/Sources,$$GITHUB_ACCESS_TOKEN,Config.swift)
	
	# Xcconfigs

	$(eval TOTAL_ITEMS = $(words $(XCCONFIG_PATHS)))
	$(foreach index, $(shell seq 1 2 $(TOTAL_ITEMS)), \
		$(eval DIR = $(word $(index), $(XCCONFIG_PATHS))) \
		$(eval FILE = $(word $(shell expr $(index) + 1), $(XCCONFIG_PATHS))) \
		$(call download_file,$(DIR),$$GITHUB_ACCESS_TOKEN,$(FILE)); \
	)
	
	# GoogleService-info
	
	$(call download_file,Projects/SOPT-iOS/Resources,$$GITHUB_ACCESS_TOKEN,GoogleService-Info.plist)
	$(call download_file,Projects/Demo/Resources,$$GITHUB_ACCESS_TOKEN,GoogleService-Info.plist)
	
	# TestConfig.swift
	
	$(call download_file,Projects/Modules/TestCore/Sources,$$GITHUB_ACCESS_TOKEN,TestConfig.swift)

update_apple_id:
	# Update Apple ID in fastlane/.env
	@if [ -f fastlane/.env ]; then \
		if [ -z "$$email" ]; then \
			read -p "Enter your Apple ID: " email; \
		fi; \
        sed -i '' '1s/.*/APPLE_ID="'"$$email"'"/' fastlane/.env; \
        echo "애플 아이디가 저장되었습니다."; \
		if [ -z "$$app_password" ]; then \
			read -p "Enter your App Password: " app_password; \
		fi; \
        sed -i '' '2s/.*/FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD="'"$$app_password"'"/' fastlane/.env; \
        echo "앱 암호가 저장되었습니다."; \
		cat fastlane/.env; \
    else \
        echo "fastlane/.env 파일이 존재하지 않습니다."; \
    fi