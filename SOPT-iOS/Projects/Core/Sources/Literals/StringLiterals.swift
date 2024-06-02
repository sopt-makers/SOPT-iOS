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
        public static let notice = "공지사항"
        public static let didCheck = "확인했어요!"
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
    
    public struct StampGuide {
        public static let title1 = "A부터 Z까지 SOPT 즐기기"
        public static let caption1 = "동아리 활동을 더욱 재미있게\n즐기는 방법을 알려드려요!"
        public static let title2 = "랭킹으로 다같이 참여하기"
        public static let caption2 = "미션을 달성하고 랭킹이 올라가는\n재미를 느껴보세요!"
        public static let title3 = "완료된 미션으로 추억 감상하기"
        public static let caption3 = "완료된 미션을 확인하며\n추억을 감상할 수 있어요!"
        public static let okay = "확인"
        public static let guide = "가이드"
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
    
    public struct MissionList {
        public static let noMission = "아직 완료한 미션이 없습니다!"
    }
    
    public struct RankingList {
        public static let noSentenceText = "설정된 한 마디가 없습니다."
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
        }
        
        public struct NicknameEdit {
            public static let nicknameEdit = "닉네임 변경"
            public static let nicknameEditSuccess = "닉네임이 변경되었습니다."
        }
        
        public struct Withdrawal {
            public static let withdrawal = "탈퇴하기"
            public static let caution = "탈퇴 시 유의사항"
            public static let guide1 = "회원 탈퇴를 신청하시면 해당 이메일은 즉시 탈퇴 처리됩니다."
            public static let guide2 = "탈퇴 처리 시 계정 내에서 입력했던 정보 (미션 정보 등)는 영구적으로 삭제되며, 복구가 어렵습니다."
            public static let withdrawalSuccess = "탈퇴처리 되었습니다"
        }
    }
    
    public struct Main {
        public static let visitor = "비회원"
        public static let active = "기 활동 중"
        public static let inactive = "기 수료"
        public static let inactiveMember = "비활동"
        public static let encourage = "안녕하세요, \nSOPT의 열정이 되어주세요!"
        public static let hello = "안녕하세요"
        public static let welcome = "안녕하세요, \nSOPT에 오신 것을 환영합니다!"
        public static let failedToGetUserInfo = "활동 정보를 가져올 수 없어요."
        public static let needToRegisterPlayground = "플레이그라운드에서 프로필을 업데이트하면\n 서비스를 원활하게 사용할 수 있어요."
        
        public static func userHistory(name: String, months: String) -> String {
            return "\(name) 님은 \nSOPT와 \(months)개월째"
        }
        
        public struct MainService {
            public static let visitorGuide = "SOPT를 더 알고 싶다면, 둘러보세요"
            public static let memberGuide = "더욱 편리해진 SOPT를 이용해보세요!"
            
            public struct MainTitle {
                public static let attendance = "출석하기"
                public static let group = "모임/스터디"
                public static let officialHomePage = "SOPT\n공식홈페이지"
                public static let playgroundCommunity = "Playground"
            }

            public struct Title {
                public static let officialHomePage = "공식 홈페이지"
                public static let review = "활동 후기"
                public static let project = "프로젝트"
                public static let faq = "FAQ"
                public static let youtube = "Youtube"
                public static let attendance = "출석하기"
                public static let member = "멤버"
                public static let group = "모임/스터디"
                public static let instagram = "Instagram"
                public static let playgroundCommunity = "Playground"
            }
            
            public struct Description {
                public struct Default {
                    public static let officialHomePage = "솝트 홈페이지 바로가기"
                    public static let review = "'진짜' 후기가\n 궁금하다면?"
                    public static let project = "역대 프로젝트 보기"
                    public static let faq = "자주 묻는 질문"
                    public static let youtube = "SOPT 활동 구경하기"
                    public static let attendance = "아 맞다, 출석!"
                    public static let member = "궁금한 사람 찾아보기"
                    public static let group = "지금 열린 모임은?"
                    public static let instagram = "SOPT 소식 빠르게 확인하기"
                    public static let playgroundCommunity = "가장 HOT한 글은?"
                }

                public struct ActiveUser {
                    public static let project = "역대 프로젝트 모아보기"
                    public static let playgroundCommunity = "가장 HOT한 글은?"
                }
                
                public struct InactiveUser {
                    public static let project = "지난 프로젝트 보기"
                    public static let playgroundCommunity = "모든 솝트와 소통하기"
                }
                
                public struct Visitor {
                    public static let project = "SOPT에서\n탄생한 프로젝트"
                }
            }
        }

        public struct AppService {
            public static let appServiceIntroduction = "SOPT를 알차게 즐기고 싶다면?"
            public static let recommendSopt = "SOPT 회원이 되어 다양한 서비스를 즐겨보세요"
            public static let soptamp = "SOPT-AMP!"
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
        public static let codeMismatch = "코드가 일치하지 않아요!"
        public static let takeAttendance = "출석하기"
        public static let take = "하기"
        
        public static let infoButtonToastMessage = "제2장 제10조(출석)를 확인해주세요"
    }
    
    public struct MyPage {
        public static let navigationTitle = "마이페이지"
        public static let servicePolicySectionTitle = "서비스 이용 방침"
        public static let privacyPolicy = "개인정보 처리 방침"
        public static let termsOfUse = "서비스 이용 약관"
        public static let sendFeedback = "의견 보내기"
        public static let alertSectionTitle = "알림 설정"
        public static let alertListItemTitle = "알림 설정하기"
        public static let alertByFeaturesListItemTitle = "기능별 알림"
        public static let soptampSectionTitle = "솝탬프 설정"
        public static let editOnlineSentence = "한 마디 편집"
        public static let editNickname = "닉네임 변경"
        public static let resetStamp = "스탬프 초기화"
        public static let etcSectionGroupTitle = "기타"
        public static let logout = "로그아웃"
        public static let resetMissionTitle = "미션을 초기화 하실건가요?"
        public static let resetMissionDescription = "사진, 메모가 삭제되고\n 전체 미션이 미완료상태로 초기화됩니다."
        public static let reset = "초기화"
        public static let resetSuccess = "초기화 되었습니다"
        public static let logoutDialogTitle = "로그아웃"
        public static let logoutDialogDescription = "정말 로그아웃을 하실 건가요?"
        public static let logoutDialogGrantButtonTitle = "로그아웃"
        public static let login = "로그인"

        public static let withdrawal = "탈퇴하기"
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
        public static let poke = "콕 찌르기"
        public static let someonePokedMe = "누가 나를 찔렀어요"
        public static let pokeMyFriends = "내 친구를 찔러보세요"
        public static let pokeNearbyFriends = "나와 공통점이 있는 친구들을 찔러보세요"
        public static let emptyFriendDescription = "아직 없어요 T.T\n내 친구가 더 많은 친구가 생길 때까지 기다려주세요"
        public static let refreshGuide = "화면을 밑으로 당기면\n다른 친구를 볼 수 있어요"
        public static let pokeSuccess = "콕 찌르기를 완료했어요"
        public static func makingFriendCompleted(name: String) -> String {
            return "찌르기 답장으로\n\(name)님과 친구가 되었어요!"
        }
      
      public struct Onboarding {
        public static let title = "익명 콕 찌르기 기능이 추가되었어요!"
        public static let description = """
        친구 단계가 올라가면 익명 친구에 대한 힌트를 알 수 있어요.
        친구와 천생연분 단계가 되면 어떤 일이 일어날까요?
        더욱 재밌어진 콕찌르기를 만나보세요!
        """
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
}

extension I18N {
    public struct ServiceUsagePolicy {
        public static let termsOfService = """
        제 1장 총칙
        제 1조
        (목적)이 약관은 “SOPT”(이하 “회사”라 합니다)가 제공하는 “SOPT 앱 서비스”(이하 ‘서비스’라 합니다)를 회사와 이용계약을 체결한 ‘고객’이 이용함에 있어 필요한 회사와 고객의 권리 및 의무, 기타 제반 사항을 정함을 목적으로 합니다.
        
        제 2조
        (약관 외 준칙)이 약관에 명시되지 않은 사항에 대해서는 위치 정보의 보호 및 이용 등에 관한 법률, 전기통신사업법, 정보통신망 이용 촉진및 보호 등에 관한 법률 등 관계법령 및 회사가 정한 서비스의 세부이용지침 등의 규정에 따릅니다.
        
        제 2장 서비스의 이용
        제 3조 (가입자격)
        ① 서비스에 가입할 수 있는 자는 Application 이 설치가능한 모든 사람 입니다.
        
        제 4조 (서비스 가입)
        ① “Application 관리자”가 정한 본 약관에 고객이 동의하면 서비스 가입의 효력이 발생합니다.
        ② “Application 관리자”는 다음 각 호의 고객 가입신청에 대해서는 이를 승낙하지 아니할 수 있습니다.
        
        1. 고객 등록 사항을 누락하거나 오기하여 신청하는 경우
        2. 공공질서 또는 미풍양속을 저해하거나 저해할 목적으로 신청한 경우
        3. 기타 회사가 정한 이용신청 요건이 충족되지 않았을 경우
        
        제 5조 (서비스의 탈퇴)
        서비스 탈퇴를 희망하는 고객은 “Application 담당자”가 정한 소정의 절차(설정메뉴의 탈퇴)를 통해 서비스 해지를 신청할 수 있습니다.
        
        제 6조 (서비스의 수준)
        ① 서비스의 이용은 연중무휴 1일 24시간을 원칙으로 합니다. 단, 회사의 업무상이나 기술상의 이유로 서비스가 일시 중지될 수 있으며, 운영상의 목적으로 회사가 정한 기간에는 서비스가 일시 중지될 수 있습니다. 이러한 경우 회사는 사전 또는 사후에 이를 공지합니다.
        ② 위치정보는 관련 기술의 발전에 따라 오차가 발생할 수 있습니다.
        
        제 7조 (서비스 이용의 제한 및 정지)
        회사는 고객이 다음 각 호에 해당하는 경우 사전 통지 없이 고객의 서비스 이용을 제한 또는 정지하거나 직권 해지를 할 수 있습니다.
        
        1. 타인의 서비스 이용을 방해하거나 타인의 개인정보를 도용한 경우
        2. 서비스를 이용하여 법령, 공공질서, 미풍양속 등에 반하는 행위를 한 경우
        
        제 8조 (서비스의 변경 및 중지)
        ① 회사는 다음 각 호의 1에 해당하는 경우 고객에게 서비스의 전부 또는 일부를 제한, 변경하거나 중지할 수 있습니다.
        
        1. 서비스용 설비의 보수 등 공사로 인한 부득이한 경우
        2. 정전, 제반 설비의 장애 또는 이용량의 폭주 등으로 정상적인 서비스 이용에 지장이 있는 경우
        3. 서비스 제휴업체와의 계약 종료 등과 같은 회사의 제반 사정 또는 법률상의 장애 등으로 서비스를 유지할 수 없는 경우
        4. 기타 천재지변, 국가비상사태 등 불가항력적 사유가 있는 경우
        
        ② 제1항에 의한 서비스 중단의 경우에는 회사는 인터넷 등에 공지하거나 고객에게 통지합니다. 다만, 회사가 통제할 수 없는 사유로 인한 서비스의 중단 (운영자의 고의, 과실이 없는 디스크 장애, 시스템 다운 등)으로 인하여 사전 통지가 불가능한 경우에는 사후에 통지합니다.
        
        제 5장 기타
        제 19조 (회사의 연락처)
        회사의 상호 다음과 같습니다.
        상호: “SOPT makers”
        이메일 주소: makers@sopt.org
        
        제 20조 (양도금지)
        고객 및 회사는 고객의 서비스 가입에 따른 본 약관상의 지위 또는 권리,의무의 전부 또는 일부를 제3자에게 양도, 위임하거나 담보제공 등의 목적으로 처분할 수 없습니다.
        
        제 21조 (손해배상)
        ① 고객의 고의나 과실에 의해 이 약관의 규정을 위반함으로 인하여 회사에 손해가 발생하게 되는 경우, 이 약관을 위반한 고객은 회사에 발생하는 모든 손해를 배상하여야 합니다.
        ② 고객이 서비스를 이용함에 있어 행한 불법행위나 고객의 고의나 과실에 의해 이 약관 위반행위로 인하여 회사가 당해 고객 이외의 제3자로부터 손해배상청구 또는 소송을 비롯한 각종 이의제기를 받는 경우 당해 고객은 그로 인하여 회사에 발생한 손해를 배상하여야 합니다.
        ③ 회사가 위치정보의 보호 및 이용 등에 관한 법률 제 15조 내지 제26조의 규정을 위반한 행위 혹은 회사가 제공하는 서비스로 인하여 고객에게 손해가 발생한 경우, 회사가 고의 또는 과실 없음을 입증하지 아니하면, 고객의 손해에 대하여 책임을 부담합니다.
        
        제 22조 (면책사항)
        ① 회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다.
        ② 회사는 고객의 귀책사유로 인한 서비스의 이용장애에 대하여 책임을 지지 않습니다.
        ③ 회사는 고객이 서비스를 이용하여 기대하는 수익을 상실한 것에 대하여 책임을 지지 않으며, 그 밖에 서비스를 통하여 얻은 자료로 인한 손해 등에 대하여도 책임을 지지 않습니다.
        ④ 회사에서 제공하는 서비스 및 서비스를 이용하여 얻은 정보에 대한 최종판단은 고객이 직접 하여야 하고, 그에 따른 책임은 전적으로 고객 자신에게 있으며, 회사는 그로 인하여 발생하는 손해에 대해서 책임을 부담하지 않습니다.
        ⑤ 회사의 업무상 또는 기술상의 장애로 인하여 서비스를 개시하지 못하는 경우 회사는 인터넷 홈페이지 등에 이를 공지하거나 E-mail 등의 방법으로 고객에게 통지합니다. 단, 회사가 통제할 수 없는 사유로 인하여 사전 공지가 불가능한 경우에는 사후에 공지합니다.
        
        제 23조 (분쟁의 해결 및 관할법원)
        ① 서비스 이용과 관련하여 회사와 고객 사이에 분쟁이 발생한 경우, 회사와 고객은 분쟁의 해결을 위해 성실히 협의합니다.
        ② 제1항의 협의에서도 분쟁이 해결되지 않을 경우 양 당사자는 정보통신망 이용촉진 및 정보보호 등에 관한 법률 제33조의 규정에 의한 개인정보분쟁조정위원회에 분쟁조정을 신청할 수 있습니다.
        """
        
        public static let privacyPolicy = """
        < sopt >('https://sopt.org/'이하 'sopt')은(는) 「개인정보 보호법」 제30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.
        
        ○ 이 개인정보처리방침은 2022년 1월 1부터 적용됩니다.
        
        제1조(개인정보의 처리 목적)
        
        < sopt >('https://sopt.org/'이하 'sopt')은(는) 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며 이용 목적이 변경되는 경우에는 「개인정보 보호법」 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.
        
        1. 홈페이지 회원가입 및 관리
        
        회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 서비스 부정이용 방지 목적으로 개인정보를 처리합니다.
        
        2. 마케팅 및 광고에의 활용
        
        접속빈도 파악 또는 회원의 서비스 이용에 대한 통계 등을 목적으로 개인정보를 처리합니다.
        
        제2조(개인정보의 처리 및 보유 기간)
        
        ① < sopt >은(는) 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.
        
        ② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.
        
        1.<홈페이지 회원가입 및 관리>
        
        <홈페이지 회원가입 및 관리>와 관련한 개인정보는 수집.이용에 관한 동의일로부터<지체없이 파기>까지 위 이용목적을 위하여 보유.이용됩니다.
        
        보유근거 : 회원제 서비스 제공에 따른 본인 인증, 식별
        
        관련법령 :
        
        예외사유 :
        
        제3조(처리하는 개인정보의 항목)
        
        ① < sopt >은(는) 다음의 개인정보 항목을 처리하고 있습니다.
        
        1< 홈페이지 회원가입 및 관리 >
        
        필수항목 : 이메일, 비밀번호, 로그인ID, 이름
        
        제4조(개인정보의 제3자 제공에 관한 사항)
        
        ① < sopt >은(는) 개인정보를 제1조(개인정보의 처리 목적)에서 명시한 범위 내에서만 처리하며, 정보주체의 동의, 법률의 특별한 규정 등 「개인정보 보호법」 제17조 및 제18조에 해당하는 경우에만 개인정보를 제3자에게 제공합니다.
        
        ② < sopt >은(는) 다음과 같이 개인정보를 제3자에게 제공하고 있습니다.
        
        제5조(개인정보처리의 위탁에 관한 사항)
        
        ① < sopt >은(는) 원활한 개인정보 업무처리를 위하여 다음과 같이 개인정보 처리업무를 위탁하고 있습니다.
        
        ② < sopt >은(는) 위탁계약 체결시 「개인정보 보호법」 제26조에 따라 위탁업무 수행목적 외 개인정보 처리금지, 기술적․관리적 보호조치, 재위탁 제한, 수탁자에 대한 관리․감독, 손해배상 등 책임에 관한 사항을 계약서 등 문서에 명시하고, 수탁자가 개인정보를 안전하게 처리하는지를 감독하고 있습니다.
        
        ③ 위탁업무의 내용이나 수탁자가 변경될 경우에는 지체없이 본 개인정보 처리방침을 통하여 공개하도록 하겠습니다.
        
        제6조(개인정보의 파기절차 및 파기방법)
        
        ① < sopt > 은(는) 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.
        
        ② 정보주체로부터 동의받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는, 해당 개인정보를 별도의 데이터베이스(DB)로 옮기거나 보관장소를 달리하여 보존합니다.
        
        1. 법령 근거 :
        
        2. 보존하는 개인정보 항목 : 계좌정보, 거래날짜
        
        ③ 개인정보 파기의 절차 및 방법은 다음과 같습니다.
        
        1. 파기절차
        
        < sopt > 은(는) 파기 사유가 발생한 개인정보를 선정하고, < sopt > 의 개인정보 보호책임자의 승인을 받아 개인정보를 파기합니다.
        
        2. 파기방법
        
        전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다
        
        제7조(미이용자의 개인정보 파기 등에 관한 조치)
        
        ① <개인정보처리자명>은(는) 1년간 서비스를 이용하지 않은 이용자의 정보를 파기하고 있습니다. 다만, 다른 법령에서 정한 보존기간이 경과할 때까지 다른 이용자의 개인정보와 분리하여 별도로 저장·관리할 수 있습니다.
        
        ② <개인정보처리자명>은(는) 개인정보의 파기 30일 전까지 개인정보가 파기되는 사실, 기간 만료일 및 파기되는 개인정보의 항목을 이메일, 문자 등 이용자에게 통지 가능한 방법으로 알리고 있습니다.
        
        ③ 개인정보의 파기를 원하지 않으시는 경우, 기간 만료 전 서비스 로그인을 하시면 됩니다.
        
        제8조(정보주체와 법정대리인의 권리·의무 및 그 행사방법에 관한 사항)
        
        ① 정보주체는 sopt에 대해 언제든지 개인정보 열람·정정·삭제·처리정지 요구 등의 권리를 행사할 수 있습니다.
        
        ② 제1항에 따른 권리 행사는sopt에 대해 「개인정보 보호법」 시행령 제41조제1항에 따라 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 sopt은(는) 이에 대해 지체 없이 조치하겠습니다.
        
        ③ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다.이 경우 “개인정보 처리 방법에 관한 고시(제2020-7호)” 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.
        
        ④ 개인정보 열람 및 처리정지 요구는 「개인정보 보호법」 제35조 제4항, 제37조 제2항에 의하여 정보주체의 권리가 제한 될 수 있습니다.
        
        ⑤ 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.
        
        ⑥ sopt은(는) 정보주체 권리에 따른 열람의 요구, 정정·삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.
        
        제9조(개인정보의 안전성 확보조치에 관한 사항)
        
        < sopt >은(는) 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.
        
        1. 내부관리계획의 수립 및 시행
        
        개인정보의 안전한 처리를 위하여 내부관리계획을 수립하고 시행하고 있습니다.
        
        2. 개인정보의 암호화
        
        이용자의 개인정보는 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다.
        
        3. 개인정보에 대한 접근 제한
        
        개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여,변경,말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.
        
        제10조(개인정보를 자동으로 수집하는 장치의 설치·운영 및 그 거부에 관한 사항)
        
        ① sopt 은(는) 이용자에게 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 ‘쿠키(cookie)’를 사용합니다.
        
        ② 쿠키는 웹사이트를 운영하는데 이용되는 서버(http)가 이용자의 컴퓨터 브라우저에게 보내는 소량의 정보이며 이용자들의 PC 컴퓨터내의 하드디스크에 저장되기도 합니다.
        
        가. 쿠키의 사용 목적 : 이용자가 방문한 각 서비스와 웹 사이트들에 대한 방문 및 이용형태, 인기 검색어, 보안접속 여부, 등을 파악하여 이용자에게 최적화된 정보 제공을 위해 사용됩니다.
        
        나. 쿠키의 설치•운영 및 거부 : 웹브라우저 상단의 도구>인터넷 옵션>개인정보 메뉴의 옵션 설정을 통해 쿠키 저장을 거부 할 수 있습니다.
        
        다. 쿠키 저장을 거부할 경우 맞춤형 서비스 이용에 어려움이 발생할 수 있습니다.
        
        제11조(행태정보의 수집·이용·제공 및 거부 등에 관한 사항)
        
        행태정보의 수집·이용·제공 및 거부등에 관한 사항
        
        <개인정보처리자명>은(는) 온라인 맞춤형 광고 등을 위한 행태정보를 수집·이용·제공하지 않습니다.
        
        제12조(추가적인 이용·제공 판단기준)
        
        < sopt > 은(는) ｢개인정보 보호법｣ 제15조제3항 및 제17조제4항에 따라 ｢개인정보 보호법 시행령｣ 제14조의2에 따른 사항을 고려하여 정보주체의 동의 없이 개인정보를 추가적으로 이용·제공할 수 있습니다.
        
        이에 따라 < sopt > 가(이) 정보주체의 동의 없이 추가적인 이용·제공을 하기 위해서 다음과 같은 사항을 고려하였습니다.
        
        > 개인정보를 추가적으로 이용·제공하려는 목적이 당초 수집 목적과 관련성이 있는지 여부
        
        > 개인정보를 수집한 정황 또는 처리 관행에 비추어 볼 때 추가적인 이용·제공에 대한 예측 가능성이 있는지 여부
        
        > 개인정보의 추가적인 이용·제공이 정보주체의 이익을 부당하게 침해하는지 여부
        
        > 가명처리 또는 암호화 등 안전성 확보에 필요한 조치를 하였는지 여부
        
        ※ 추가적인 이용·제공 시 고려사항에 대한 판단기준은 사업자/단체 스스로 자율적으로 판단하여 작성·공개함
        
        제13조(가명정보를 처리하는 경우 가명정보 처리에 관한 사항)
        
        < sopt > 은(는) 다음과 같은 목적으로 가명정보를 처리하고 있습니다.
        
        > 가명정보의 처리 목적
        
        - 회원 식별 및 랭킹 노출을 위해 닉네임을 수집하고 있습니다.
        
        > 가명정보의 처리 및 보유기간
        
        - 탈퇴 시 즉시 파기됩니다.
        
        제14조 (개인정보 보호책임자에 관한 사항)
        
        ① sopt 은(는) 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.
        
        > 개인정보 보호책임자
        
        성명: 솝트 메이커스
        
        직책: 임원진
        
        직급: 임원진
        
        연락처 :makers@sopt.org
        
        ※ 개인정보 보호 담당부서로 연결됩니다.
        
        제17조(정보주체의 권익침해에 대한 구제방법)
        
        정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다. 이 밖에 기타 개인정보침해의 신고, 상담에 대하여는 아래의 기관에 문의하시기 바랍니다.
        
        1. 개인정보분쟁조정위원회 : (국번없이) 1833-6972 (www.kopico.go.kr)
        
        2. 개인정보침해신고센터 : (국번없이) 118 (privacy.kisa.or.kr)
        
        3. 대검찰청 : (국번없이) 1301 (www.spo.go.kr)
        
        4. 경찰청 : (국번없이) 182 (ecrm.cyber.go.kr)
        
        「개인정보보호법」제35조(개인정보의 열람), 제36조(개인정보의 정정·삭제), 제37조(개인정보의 처리정지 등)의 규정에 의한 요구에 대 하여 공공기관의 장이 행한 처분 또는 부작위로 인하여 권리 또는 이익의 침해를 받은 자는 행정심판법이 정하는 바에 따라 행정심판을 청구할 수 있습니다.
        
        ※ 행정심판에 대해 자세한 사항은 중앙행정심판위원회(www.simpan.go.kr) 홈페이지를 참고하시기 바랍니다.
        
        제19조(개인정보 처리방침 변경)
        
        ① 이 개인정보처리방침은 2022년 1월 1부터 적용됩니다.
        """
    }
}
