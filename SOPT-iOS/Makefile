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

download-privates:

	# Get Github Access Token
	@if [ ! -f .env ]; then \
		read -p "Enter your GitHub access token: " token; \
		echo "GITHUB_ACCESS_TOKEN=$$token" > .env; \
	else \
		/bin/bash -c "source .env; make _download-privates"; \
		exit 0; \
	fi
	
	make _download-privates

_download-privates:
	
	$(eval export $(shell cat .env))
	
	# fastlane .env

	@if [ ! -d fastlane ]; then \
		mkdir -p fastlane; \
	fi
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o fastlane/.env $(BASE_URL)/fastlane/.env
	
	# Config.swift
	
	@if [ ! -d Projects/Modules/Network/Sources ]; then \
		mkdir -p Projects/Modules/Network/Sources; \
	fi
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o Projects/Modules/Network/Sources/Config.swift $(BASE_URL)/Projects/Modules/Network/Sources/Config.swift
	
	# Xcconfigs

	@if [ ! -d xcconfigs/Base ]; then \
		mkdir -p xcconfigs/Base/Projects; \
		mkdir -p xcconfigs/Base/Targets; \
	fi

	@if [ ! -d xcconfigs/targets ]; then \
		mkdir -p xcconfigs/targets; \
	fi
	
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o xcconfigs/Base/Common.xcconfig $(BASE_URL)/xcconfigs/Base/Common.xcconfig
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o xcconfigs/Base/Projects/Project-Development.xcconfig $(BASE_URL)/xcconfigs/Base/Projects/Project-Development.xcconfig
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o xcconfigs/Base/Projects/Project-PROD.xcconfig $(BASE_URL)/xcconfigs/Base/Projects/Project-PROD.xcconfig
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o xcconfigs/Base/Projects/Project-QA.xcconfig $(BASE_URL)/xcconfigs/Base/Projects/Project-QA.xcconfig
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o xcconfigs/Base/Projects/Project-Test.xcconfig $(BASE_URL)/xcconfigs/Base/Projects/Project-Test.xcconfig
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o xcconfigs/Base/Projects/Shared.xcconfig $(BASE_URL)/xcconfigs/Base/Projects/Shared.xcconfig
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o xcconfigs/Base/Targets/Application.xcconfig $(BASE_URL)/xcconfigs/Base/Targets/Application.xcconfig
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o xcconfigs/Base/Targets/Extension.xcconfig $(BASE_URL)/xcconfigs/Base/Targets/Extension.xcconfig
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o xcconfigs/Base/Targets/Framework.xcconfig $(BASE_URL)/xcconfigs/Base/Targets/Framework.xcconfig
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o xcconfigs/Base/Targets/StaticLibrary.xcconfig $(BASE_URL)/xcconfigs/Base/Targets/StaticLibrary.xcconfig
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o xcconfigs/targets/iOS-Demo.xcconfig $(BASE_URL)/xcconfigs/targets/iOS-Demo.xcconfig
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o xcconfigs/targets/iOS-Framework.xcconfig $(BASE_URL)/xcconfigs/targets/iOS-Framework.xcconfig
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o xcconfigs/targets/iOS-StaticFramework.xcconfig $(BASE_URL)/xcconfigs/targets/iOS-StaticFramework.xcconfig
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o xcconfigs/targets/iOS-Tests.xcconfig $(BASE_URL)/xcconfigs/targets/iOS-Tests.xcconfig
	
	# GoogleService-info

	@if [ ! -d Projects/SOPT-iOS/Resources ]; then \
		mkdir -p Projects/SOPT-iOS/Resources; \
	fi
	
	@if [ ! -d Projects/Demo/Resources ]; then \
		mkdir -p Projects/Demo/Resources; \
	fi
	
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o Projects/SOPT-iOS/Resources/GoogleService-Info.plist $(BASE_URL)/Projects/SOPT-iOS/Resources/GoogleService-Info.plist
	curl -H "Authorization: token $$GITHUB_ACCESS_TOKEN" -o Projects/Demo/Resources/GoogleService-Info.plist $(BASE_URL)/Projects/Demo/Resources/GoogleService-Info.plist
