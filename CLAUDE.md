# SOPT-iOS

SOPT 공식 iOS 앱. Tuist 기반 멀티모듈 프로젝트이며, 앱 프로젝트는 `SOPT-iOS/` 아래에 있다.

## 프로젝트 구조 (`SOPT-iOS/Projects`)

| 레이어 | 경로 | 역할 |
|---|---|---|
| Features | `Features/<Name>Feature` | 화면 단위 기능 모듈 (VC, ViewModel, Coordinator) |
| Domain | `Domain` | UseCase, Repository 인터페이스, 도메인 모델 |
| Data | `Data` | Repository 구현, DTO, 네트워크 연동 |
| Core | `Core` | 공통 유틸, 확장, 베이스 클래스 |
| Modules | `Modules/{DSKit,Networks,...}` | 디자인 시스템(MDS 우선, 미마이그레이션 영역은 DSKit), 네트워크 등 독립 모듈 |

의존 방향: `Features → Domain ← Data`, 모두 `Core`/`Modules`에 의존할 수 있다.
Features 간 직접 의존은 금지하고, 다른 Feature 호출은 `Interface` 모듈의 프로토콜을 통한다.

### Feature 모듈 구성

```
<Name>Feature/
├── Interface/Sources   # Buildable / Presentable 프로토콜 (외부 공개 계약)
├── Sources             # 구현 (Scene/VC/ViewModel/Views, Coordinator)
├── Demo                # 단독 실행용 데모 앱
├── Tests
└── Project.swift
```

- 화면 생성은 `Builder`(Buildable 구현)가 담당하고, 화면 전환은 `Coordinator`가 담당한다.
- ViewModel은 `Input`/`Output` 구조와 Combine을 사용한다. 화면 전환 트리거는 VC가 아니라 ViewModel에서 발생시킨다.

## 빌드

```bash
cd SOPT-iOS
tuist install
tuist generate --no-open
```

- 워크스페이스: `SOPT-iOS/SOPT-iOS.xcworkspace`
- `SOPT-iOS` 스킴: 운영(prod) 서버
- `SOPT-iOS-Demo-Test` 스킴: 개발(dev) 서버. `configuration=Test`로 빌드한다. Debug로 빌드하면 운영 서버로 붙고 강제 업데이트 모달이 뜬다.
- `SOPT-iOS-DEV` 스킴은 사용하지 않는다.
- SwiftLint 설정: `SOPT-iOS/.swiftlint.yml`

## 코드 컨벤션

- 새 파일은 기존 파일의 헤더 주석, MARK 구분(`// MARK: - Trigger / Properties / Inputs / Outputs / init`) 형식을 따른다.
- UI는 MDS 컴포넌트를 사용한다. 아직 MDS로 마이그레이션되지 않은 부분은 DSKit을 사용한다. 하드코딩된 색상, 폰트 값은 지양한다.
- 새로 작성하는 UI에서 DSKit 대신 MDS를 쓸 수 있는데도 DSKit을 쓰지 않도록 주의한다.
- 비동기 구독은 `CancelBag`에 보관하고, 클로저에서는 순환 참조를 피하기 위해 `[weak self]`를 사용한다.
- 커밋 메시지: `[Type] #이슈번호 - 설명` (예: `[Fix] #965 - UI 버그 수정`). Type은 Feat, Fix, Refactor, Chore 등.
- PR은 `develop` 브랜치 대상이며 `.github/PULL_REQUEST_TEMPLATE.md`를 따른다.

## 코드 리뷰 가이드

리뷰는 **한국어**로 작성한다. 먼저 봐야 할 문제부터 심각도(Critical → High → Medium → Low) 순으로 정리한다.

### 먼저 봐야 할 문제

| 심각도 | 기준 | 예시 |
|---|---|---|
| **Critical** | 즉시 사고로 이어질 수 있는 문제 (보안, 데이터 유실 등) | 키/토큰/개인정보의 코드·로그 노출, 사용자 데이터가 지워지거나 덮어써지는 로직 |
| **High** | 실제 버그로 이어질 수 있는 문제 | force unwrap(`!`), 범위 밖 배열 접근, 메인 스레드가 아닌 곳의 UI 업데이트, `[weak self]` 누락으로 인한 retain cycle, `CancelBag`에 저장되지 않아 즉시 해제되는 구독, 언어/타입별 포맷 불일치 |

### 개선 제안

| 심각도 | 기준 | 예시 |
|---|---|---|
| **Medium** | 구조, 유지보수성, UI 컨벤션 등 살펴볼 가치가 있는 개선 | Feature 간 직접 의존, VC에 비즈니스 로직/화면 전환 로직 포함, Domain이 Data/UIKit에 의존, MDS 컴포넌트가 있는데 DSKit을 새로 사용(미마이그레이션 영역의 DSKit은 허용), 하드코딩한 색상/폰트/아이콘 |
| **Low** | 스타일, 일관성, 최적화 등 가볍게 다듬을 수 있는 제안 | 네이밍/MARK 형식 불일치, PR과 무관한 변경, 불필요한 파일(`.DS_Store`, 빌드 산출물), 사소한 성능 개선 |

SwiftLint가 잡는 단순 스타일 지적은 생략한다.

### 리뷰 형식
- 각 지적은 `[Critical]`, `[High]`, `[Medium]`, `[Low]` 라벨을 앞에 붙이고, 파일/라인, 문제, 수정 제안 순서로 간결하게 쓴다.
- Critical/High는 문제가 확실한 것만 지적하고, 추측은 "확인 필요"로 표시한다.
- 요약 코멘트에는 심각도별 개수를 먼저 적는다. (예: Critical 0 · High 1 · Medium 2 · Low 3)
- 문제가 없으면 장황한 칭찬 대신 한두 줄로 요약한다.
