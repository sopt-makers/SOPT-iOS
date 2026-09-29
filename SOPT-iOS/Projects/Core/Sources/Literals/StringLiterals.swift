//
//  StringLiterals.swift
//  Core
//
//  Created by 양수빈 on 2022/10/06.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct I18N {
    public struct Default {
        public static let error = "에러"
        public static let networkError = "네트워크가 원활하지 않습니다."
        public static let networkErrorDescription = "인터넷 연결을 확인하고 다시 시도해 주세요."
        public static let delete = "삭제"
        public static let cancel = "취소"
        public static let ok = "확인"
    }
    
    public struct Notice {
        public static let didCheck = "확인했어요"
        public static let goToUpdate = "업데이트 하기"
        public static let close = "닫기"
    }
    
    public struct Photo {
        public static let authTitle = "앨범 접근 권한 거부"
        public static let authMessage = "앨범 접근이 거부되었습니다. 앱의 일부 기능을 사용할 수 없습니다."
        public static let moveToSetting = "권한 설정으로 이동하기"
        public static let wrongAuth = "권한 설정이 이상하게 되었어요"
    }
    
    public struct TextFieldView {
        public static let verify = "확인"
    }
    
    public struct Auth {
        public struct OAuth {
            public static let googleLogin = "Google로 로그인"
            public static let appleLogin = "Apple로 로그인"
        }
        
        public struct PhoneVerify {
            public static let title = "SOPT 회원인증"
            public static let description = "이곳은 SOPT 회원만을 위한 공간이에요.\nSOPT 회원인증을 위해 전화번호를 입력해 주세요."
            
            public static let phoneLabel = "전화번호"
            public static let phonePlaceholder = "010XXXXXXXX"
            public static let sendButtonTitle = "전송하기"
            public static let resendButtonTitle = "재전송하기"
            public static let sendSuccessToast = "인증번호가 전송되었어요."
            
            public static let codePlaceholder = "인증번호를 입력해주세요."
            public static let defaultTimerText = "03:00"
            public static let keyboardDoneButtonTitle = "완료"
            
            public static let helpDescription = "번호가 바뀌었거나, 인증이 어려우신 경우 추가 정보 인증을 통해 가입을 도와드리고 있어요!"
            public static let inquireButtonTitle = "문의하기"
            public static let doneButtonTitle = "SOPT 회원 인증 완료"
        }

        public struct SocialLink {
            public static let title = "소셜 계정 연동"
            public static let description = "반갑습니다 회원님\n소셜로그인을 진행하여 회원가입을 완료해주세요"
        }

        public struct SocialReset {
            public static let title = "소셜 계정 재설정"
            public static let description = "반갑습니다 회원님\n재설정할 소셜 계정을 선택해주세요"
            public static let changeSuccessToast = "소셜 계정 변경에 성공했습니다."
        }
    }
    
    public struct SignIn {
            public static let signIn = "SOPT Playground로 로그인"
            public static let notMember = "SOPT 회원이 아니에요"
            public static let id = "ID"
            public static let enterID = "이메일을 입력해주세요."
            public static let password = "Password"
            public static let enterPW = "비밀번호를 입력해주세요."
            public static let checkAccount = "정보를 다시 확인해 주세요."
            public static let findAccount = "계정 찾기"
            public static let findDescription = "아래 구글 폼을 제출해 주시면\n평일 기준 3-5일 이내로\n아이디 / 임시 비밀번호를 전송 드립니다."
            public static let findEmail = "이메일 찾기"
            public static let findPassword = "비밀번호 찾기"
        
        public struct Refactor {
            public static let playgroundLogin = "SOPT Playground로 로그인"
            public static let helpLogin = "로그인이 안 되나요?"
            public static let loginLater = "나중에 로그인할래요."
            public static let or = "또는"
            public static let signUp = "SOPT 회원가입"
            public static let wantToKnowAccount = "로그인 했던 방법을 알고 싶어요."
            public static let resetSocialAccount = "로그인 계정을 변경하고 싶어요."
            public static let inquireToKakaoTalk = "카카오톡 채널에 문의할게요."
            public static let userNotFound = "앗! 회원 정보를 찾을 수 없어요."
            public static let userInfo = "회원 정보"
            public static let signUpFirst = "먼저 회원가입 후, 다시 로그인해주세요."
            public static let retryLogin = "다시 로그인하기"
        }
    }

    
    public struct SignUp {
        public static let signUp = "회원가입"
        public static let nickname = "닉네임"
        public static let nicknameTextFieldPlaceholder = "한글/영문 10자 이하로 입력해주세요."
        public static let email = "이메일"
        public static let emailTextFieldPlaceholder = "이메일을 입력해주세요."
        public static let password = "비밀번호"
        public static let passwordTextFieldPlaceholder = "영문, 숫자, 특수문자 포함 8-15자로 입력해주세요."
        public static let passwordCheckTextFieldPlaceholder = "확인을 위해 비밀번호를 한 번 더 입력해주세요."
        public static let register = "가입하기"
        public static let validNickname = "사용 가능한 이름입니다."
        public static let duplicatedNickname = "사용 중인 이름입니다."
        public static let validEmail = "사용 가능한 이메일입니다."
        public static let duplicatedEmail = "사용 중인 이메일입니다."
        public static let invalidEmailForm = "잘못된 이메일 형식입니다."
        public static let invalidPasswordForm = "영문, 숫자, 특수문자 포함 8-15자로 입력해주세요."
        public static let passwordNotAccord = "비밀번호가 일치하지 않습니다."
        public static let signUpComplete = "가입 완료"
        public static let signUpFail = "회원가입 실패"
        public static let welcome = "SOPTAMP에 오신 것을 환영합니다"
        public static let start = "시작하기"
    }
    
    public struct Soptamp {
        public static let title = "솝탬프"
    }
    
    public struct MissionList {
        public static let noMission = "아직 완료한 미션이 없습니다!"
        public static let multipleTen = "x 10"
        public static let specialMission = "특별미션"
        public static let inactiveUserAlertTitle = "솝탬프 안내"
        public static let inactiveUserAlertDescription = "각 미션의 인증 내용은 개인, 앱잼팀 랭킹에서\n확인해주세요."
        public static let allMission = "전체 미션"
        public static let completeMission = "완료 미션"
        public static let uncompleteMission = "미완료 미션"
        public static let appjamMission = "앱잼 미션"
        public static let appjamMissionNotice = "내가 앱잼 미션을 인증하면\n우리 앱잼팀의 오늘 쌓은 점수와 총 점수에 더해져요!"
    }

    public struct RankingList {
        public static let noSentenceText = "설정된 한 마디가 없습니다."
        public static let partRankingTitle = "파트별 랭킹"
        public static let personalRankingTitle = "개인별 랭킹"
        public static let appJamTeamStatusTitle = "앱잼팀 현황"
        public static let myRanking = "내 랭킹 보기"
    }
    
    public struct AppJamRankingList {
        public static let navigationTitle = "앱잼팀 현황"
        public static let appjamMissionTitle = "따끈따끈 지금 앱잼팀은?"
        public static let appjamMissionSubTitle = "다른 팀들은 방금 이런 미션을 달성했어요"
        
        public static let todayMissionAchievementBoardTitle = "오늘의 미션 달성 보드"
        public static let todayMissionAchievementBoardSubTitle = "오늘 미션 인증하고 추가 점수를 획득해보세요!"
    }
    
    public struct ListDetail {
        public static let imagePlaceHolder = "달성 사진을 올려주세요"
        public static let memoPlaceHolder = "함께한 사람과 어떤 추억을 남겼는지 작성해 주세요."
        public static let mission = "미션"
        public static let missionComplete = "미션 완료"
        public static let editComplete = "수정 완료"
        public static let editCompletedToast = "수정 완료되었습니다."
        public static let deleteTitle = "달성한 미션을 삭제하시겠습니까?"
        public static let missionDatePlaceHolder = "날짜를 입력해주세요."
        public static let datePickerDoneButtonTitle = "완료"
        public static let datePickerCancelButtonTitle = "취소"
        public static let viewClapButtonTitle = "누가 박수쳤을까요?"
        public static let clapList = "박수 목록"
        public static let emptyClapList = "아직 박수친 솝트인이 없어요"
        public static let myMission = "내 미션"
    }
    
    public struct Setting {
        public static let setting = "설정"
        public static let myinfo = "내 정보"
        public static let bioEdit = "한 마디 편집"
        public static let passwordEdit = "비밀번호 변경"
        public static let nicknameEdit = "닉네임 변경"
        public static let serviceUsagePolicy = "서비스 이용방침"
        public static let personalInfoPolicy = "개인정보처리방침"
        public static let serviceTerm = "서비스 이용 약관"
        public static let suggestion = "서비스 의견 제안"
        public static let mission = "미션"
        public static let resetStamp = "스탬프 초기화"
        public static let resetMissionTitle = "스탬프를 초기화 하시겠습니까?"
        public static let resetMissionDescription = "사진, 메모가 삭제되고\n 전체 미션이 미완료상태로 초기화됩니다."
        public static let reset = "초기화"
        public static let resetSuccess = "초기화 되었습니다"
        public static let logout = "로그아웃"
        public static let withdraw = "탈퇴하기"
        public static let passwordEditSuccess = "비밀번호가 변경되었습니다."
        public static let passwordEditFail = "비밀번호 변경 실패"
        
        public struct SentenceEdit {
            public static let sentenceEdit = "한 마디 편집"
            public static let save = "저장"
            public static let sentenceEditSuccess = "한 마디가 변경되었습니다."
            public static let noSentenceText = "설정된 한 마디가 없습니다."
        }
        
        public struct NicknameEdit {
            public static let nicknameEdit = "닉네임 변경"
            public static let nicknameEditSuccess = "닉네임이 변경되었습니다."
        }
        
        public struct Withdrawal {
            public static let withdrawal = "탈퇴하기"
            public static let caution = "탈퇴 시 유의사항"
            public static let guide1 = "회원 탈퇴를 신청하시면 해당 이메일은 즉시 탈퇴 처리\n됩니다."
            public static let guide2 = "탈퇴 처리 시 계정 내에서 입력했던 정보는 영구적으로 삭제되며, 복구가 어렵습니다."
            public static let withdrawalSuccess = "탈퇴처리 되었습니다"
        }
    }
    
    public struct Main {
        public static let visitor = "비회원"
        public static let active = "기 활동 중"
        public static let inactive = "기 수료"
    }
    
    public struct TabBar {
        public static let playground = "플레이그라운드"
        public static let groupAndStudy = "모임/스터디"
        public static let homepage = "홈페이지"
        
        public struct Playground {
            public static let write = "글쓰기"
        }
        
        public struct GroupAndStudy {
            public static let makeGroup = "모임 개설"
            public static let makeLightGroup = "번쩍 개설"
            public static let writeFeed = "피드 작성"
        }
        
        public struct Homepage {
            public static let reviewUpload = "활동후기 업로드"
        }
    }
    
    public struct Home {
        public static let viewAll = "전체보기"
        public static let title = "홈"
        
        public struct PopUp {
            public static let login = "로그인"
            public static let needToLogin = "로그인이 필요해요"
            public static let needToLoginDetail = "앱 서비스는 로그인을 해야만 사용할 수 있어요.\n솝트 회원이라면 로그인해주세요."
        }
        
        public struct DashBoard {
            public struct UserHistory {
                public static let visitor = "비회원"
                public static let active = "기 활동 중"
                public static let inactive = "기 수료"
                public static let inactiveMember = "비활동"
                public static let encourage = "안녕하세요.\nSOPT의 열정이 되어주세요!"
            }
            
            public struct Attendance {
                public static let attendance = "출석"
                public static let event = "행사"
                public static let seminar = "세미나"
                public static let jointSeminar = "합동 세미나"
                public static let `break` = "휴식"
            }
        }
        
        public struct MainProduct {
            public static let headerTitleForVisitor = "SOPT를 더 알고 싶다면, 둘러보세요"
            public static let soptPlayground = "SOPT Playground"
            public static let groupAndStudy = "모임/스터디"
            public static let member = "멤버"
            public static let project = "프로젝트"
            public static let coffeechat = "커피솝"
            public static let homePage = "홈페이지"
            public static let activityReview = "활동후기"
            public static let instagram = "인스타그램"
        }
        
        public struct AppService {
            public static let headerTitle = "SOPT 더 재밌게 즐기기!"
            public static let soptletter = "솝레터"
        }
        
        public struct PopularPosts {
            public static let headerTitle = "지금 인기 소식"
            public static let morePosts = "다른 게시물 보러가기"
        }
        
        public struct LatestPosts {
            public static let headerTitle = "최신 게시물"
        }

        public struct SocialLink {
            public static let homePage = "홈페이지"
            public static let instagram = "인스타"
            public static let youtube = "유튜브"
        }
        
        public struct CalendarDetail {
            public static let navigationTitle = "일정"
            public static let attendance = "출석하러 가기"
        }
    }
    
    public struct Soptlog {
        public static let navigationTitle = "마이 솝트로그"
        public static let tapTitle = "솝트로그"
        public static let editProfile = "프로필 수정"
        public static let enrollIntroduce = "프로필 수정에서 한 줄 소개 등록해보세요!"
        public static let soptlevel = "솝레벨"
        public static let poke = "콕찌르기 로그"
        public static let soptamp = "솝탬프 로그"
        public static let withSopt = "솝트와"
        public static let toolTipTitle = "조회수"
        public static let toolTip = """
                                    솝트 전체 회원들이 내 솝탬프 미션을
                                    조회한 횟수를 의미해요.
                                    """
        public struct Menu {
            public static let completedMission = "완료 미션"
            public static let views = "조회수"
            public static let receivedClapCount = "받은 박수"
            public static let clapCount = "쳐준 박수"

            public static let pokeCount = "총 콕찌르기"
            public static let newFriend = "친한 친구"
            public static let bestFriend = "단짝 친구"
            public static let soulmate = "천생 연분"
        }
    }
    
    public struct Attendance {
        public static func nthAttendance(_ idx: Int) -> String {
            return "\(idx)차 출석"
        }
        public static let beforeAttendance = "출석 전"
        public static let completeAttendance = "출석완료!"
        public static let unCheckAttendance = "-"
        
        public static let attendance = "출석"
        public static let absent = "결석"
        public static let tardy = "지각"
        public static let leaveEarly = "조퇴"
        public static let participate = "참여"
        public static let all = "전체"
        
        public static let planPart = "기획파트"
        public static let designPart = "디자인파트"
        public static let webPart = "웹파트"
        public static let iosPart = "iOS파트"
        public static let aosPart = "안드로이드파트"
        public static let serverPart = "서버파트"
        
        public static let today = "오늘은 "
        public static let dayIs = " 날이에요"
        public static let unscheduledDay = "일정이 없는"
        public static let noAttendanceSession = "출석 점수가 반영되지 않아요."
        public static let currentAttendanceScore = "현재 출석점수는 "
        public static let scoreIs = " 입니다!"
        public static let myAttendance = "나의 출결 현황"
        public static let count = "회"
        
        public static let beforeFirstAttendance = "1차 출석 시작 전"
        public static func afterNthAttendance(_ idx: Int) -> String {
            return "\(idx)차 출석 종료"
        }
        public static func takeNthAttendance(_ idx: Int) -> String {
            return "\(idx)차 출석 인증하기"
        }
        public static let giveFeedback = "피드백 남기기"
        
        public static let inputCodeDescription = "출석 코드 다섯 자리를 입력해주세요."
        public static let codeMismatch = "코드가 일치하지 않아요"
        public static let takeAttendance = "출석하기"
        public static let take = "하기"
        
        public static let infoButtonToastMessage = "제2장 제10조(출석)를 확인해주세요"
    }
    
    public struct MyPage {
        public static let title = "마이페이지"
        public static let editProfile = "프로필 수정"
        public static let checkSoptlog = "마이 솝트로그 확인하기"

        public struct ServicePolicySection {
            public static let title = "서비스 이용 방침"
            public static let privacyPolicy = "개인정보처리방침"
            public static let termsOfUse = "서비스 이용 약관"
            public static let sendFeedback = "의견 보내기"
        }

        public struct NotificationSection {
            public static let title = "알림 설정"
            public static let setNotification = "알림"
        }
        
        public struct SoptampSection {
            public static let title = "솝탬프 설정"
            public static let editOnelineSentence = "한 마디 편집"
            public static let resetStamp = "스탬프 초기화"
        }
        
        public struct EtcSection {
            public static let title = "기타"
            public static let logout = "로그아웃"
            public static let withdrawal = "탈퇴하기"
            public static let login = "로그인"
        }
        
        public static let fetchErrorToast = "잠시 문제가 발생했습니다. 다시 시도해주세요"
        public static let resetMissionTitle = "솝탬프 미션을 초기화 하실 건가요?"
        public static let resetMissionDescription = "미션에 등록된 사진, 메모가 삭제되고\n전체 미션이 미완료 상태로 초기화됩니다."
        public static let reset = "초기화"
        public static let resetSuccess = "초기화 되었습니다"
        public static let logoutDialogTitle = "로그아웃 하실 건가요?"
        public static let logoutDialogDescription = "로그아웃을 해도 언제든 솝트에\n다시 접속할 수 있어요."
        public static let logoutDialogGrantButtonTitle = "로그아웃"
        public static let withdrawalDialogTitle = "정말 탈퇴하실 건가요?"
        public static let withdrawalDialogDescription = "탈퇴하면 저장된 정보가 모두 삭제되며\n다시 복구할 수 없어요."
    }
    
    public struct NotificationSettingsByFeature {
        public static let navigationTitle = "기능 별 알림"
        public static let notificationSectionDescrition = "필요한 기능을 선택하면 알림을 보내드려요."
        public static let allNotificationListItemTitle = "전체 알림"
        public static let notificaitonByPartListItemTitle = "파트별 알림"
        public static let infoNotificationListItemTitle = "소식 알림"
    }
    
    public struct Notification {
        public static let notification = "알림"
        public static let readAll = "모두 읽음"
        public static let emptyNotification = "아직 도착한 알림이 없어요."
        public static let shortcut = "바로가기"
    }
    
    public struct DeepLink {
        public static let updateAlertTitle = "업데이트 안내"
        public static let updateAlertDescription = "현재 버전에서는 이동할 수 없는 링크에요.\nSOPT 앱을 최신 버전으로 업데이트해 주세요."
        public static let expiredLinkTitle = "유효하지 않은 링크"
        public static let expiredLinkDesription = "해당 링크의 유효기간이 만료되어\n더 이상 내용을 확인할 수 없어요."
        public static let updateAlertButtonTitle = "확인"
    }
    
    public struct WebView {
        public static let close = "닫기"
    }
    
    public struct Poke {
        public static let title = "콕찌르기"
        public static let poke = "콕 찌르기"
        public static let someonePokedMe = "누가 나를 찔렀어요"
        public static let pokeMyFriends = "내 친구를 찔러보세요"
        public static let pokeNearbyFriends = "나와 공통점이 있는 친구들을 찔러보세요"
        public static let emptyFriendDescription = "아직 없어요 T.T\n내 친구가 더 많은 친구가 생길 때까지 기다려주세요"
        public static let refreshGuide = "화면을 밑으로 당기면\n다른 친구를 볼 수 있어요"
        public static let pokeSuccess = "콕 찌르기를 완료했어요."
        public static func makingFriendCompleted(name: String) -> String {
            return "찌르기 답장으로\n\(name)님과\n친구가 되었어요!"
        }
      
      public struct OnboardingBottomSheet {
        public static let title = "익명 콕 찌르기 기능이 추가되었어요!"
        public static let description = """
        친구 단계가 올라가면 익명 친구에 대한 힌트를 알 수 있어요.
        친구와 천생연분 단계가 되면 어떤 일이 일어날까요?
        더욱 재밌어진 콕찌르기를 만나보세요!
        """
      }
      
      public struct Onboarding {
        public static let title = "익명 콕 찌르기 기능이 추가되었어요!"
        public static let description = """
            친구 단계가 올라가면 익명 친구에 대한 힌트를 알 수 있어요.
            친구와 천생연분 단계가 되면 어떤 일이 일어날까요?
            더욱 재밌어진 콕찌르기를 만나보세요!
            """
        public static let footerPullToRefreshDescription = "화면을 당기면 다른 친구들을 볼 수 있어요"
      }
      
      public struct MyFriends {
        public static let myFriends = "내 친구"
        public static let newFriends = "나랑 친한친구"
        public static let bestFriend = "나랑 단짝친구"
        public static let soulmate = "나랑 천생연분"
        public static func friendsBaseline(_ count: Int) -> String {
          return "\(count)번 이상 찌르면 될 수 있어요"
        }
        public static let emptyViewDescription = "아직 없어요 T.T\n나와 비슷한 친구가 생길 때까지 기다려주세요"
      }
      public static let emptyViewDescription = "아직 없어요 T.T\n더 많은 찌르기로 달성해보세요"
    }

    public struct Soptletter {
        public static let navigationTitle = "솝레터 작성"
        public static let descriptionText = "나와 같은 기수의 SOPT\n회원들에게 전하고 싶은 말을\n자유롭게 적어보세요."
        public static let recipient = "익명의 무무"
        public static let placeholder = "나와 같은 기수의 솝트인들에게 전하고 싶은 말을 자유롭게 적어보세요."
        public static let charLimit = "0/350자"
        public static let charLimitError = "공백 포함 350자 이하로만 작성할 수 있어요."
        public static let submitButton = "작성 완료"
        public static let submitSuccess = "메세지 작성을 완료했어요."
        public static let submitFailure = "실패했습니다"
        
        public struct Onboarding {
            public static let descriptionText = """
            우리 기수 회원들에게 하고 싶은 말을 남겨보세요.
            익명으로 부담없이 마음을 전할 수 있어요.
            추억을 남기고, 우리 기수만의 기록을 쌓아보세요.
            """
            public static let startButtonTitle = "솝레터 시작하기"
            public static let goButtonTitle = "기 솝레터 바로가기"
        }
        
        public struct Print {
            public static let printButtonTitle = "솝레터 출력"
            public static let previewTitle = "미리보기에서는 최대 16개까지 확인할 수 있어요."
            public static let savePdfButtonTitle = "PDF 저장하기"
            public static let saveFailure = "이미지 저장에 실패했어요."
            public static let saveSuccess = "이미지 저장을 완료했어요."
            public static let printSoptletter = "솝레터 출력하기"
        }
        
        public struct Nickname {
            public static let descriptionText = "기 솝레터에 입장할 준비 되셨나요?\n솝레터는 100% 익명이에요."
            public static let myNicknameText = "나의 닉네임은"
        }
        
        public static let topicTitle = "솝레터 주제"

        public struct Detail {
            public static let confirmTitle = "확인"
            public static let editCompleteTitle = "수정완료"
            public static let editCompleteToast = "메세지 수정을 완료했어요."
            public static let deleteCompleteToast = "메세지 삭제를 완료했어요."
            public static let deleteAlertTitle = "솝레터 삭제하기"
            public static let deleteAlertDescription = "해당 솝레터가 영구적으로 삭제되어요.\n그래도 삭제하시겠어요?"
            public static let deleteButtonTitle = "삭제"
            public static let cannotLikeOwnMessage = "내가 작성한 솝레터에는 좋아요를 누를 수 없어요."
        }
    }
}

extension I18N {
    public struct ForceUpdate {
        public static let alertTitle = "업데이트 안내"
        public static let description = "현재 버전에서는 이동할 수 없는 링크에요.\nSOPT앱을 최신버전으로 업데이트 해주세요."
    }
}
