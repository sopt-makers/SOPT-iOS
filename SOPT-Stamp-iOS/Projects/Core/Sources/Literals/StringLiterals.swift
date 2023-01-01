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
        public static let networkError = "네트워크 오류가 발생했습니다."
        public static let delete = "삭제"
        public static let cancel = "취소"
        public static let ok = "확인"
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
    
    public struct Onboarding {
        public static let title1 = "A부터 Z까지 SOPT 즐기기"
        public static let caption1 = "동아리 활동을 더욱 재미있게\n즐기는 방법을 알려드려요!"
        public static let title2 = "랭킹으로 다같이 참여하기"
        public static let caption2 = "미션을 달성하고 랭킹이 올라가는\n재미를 느껴보세요!"
        public static let title3 = "완료된 미션으로 추억 감상하기"
        public static let caption3 = "완료된 미션을 확인하며\n추억을 감상할 수 있어요"
        public static let start = "시작하기"
    }
    
    public struct SignIn {
        public static let id = "ID"
        public static let enterID = "이메일을 입력해주세요."
        public static let password = "Password"
        public static let enterPW = "비밀번호를 입력해주세요."
        public static let checkAccount = "정보를 다시 확인해 주세요."
        public static let findAccount = "계정 찾기"
        public static let signIn = "로그인"
        public static let signUp = "회원가입"
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
        public static let invalidEmailForm = "잘못된 이메일 형식입니다."
        public static let invalidPasswordForm = "영문, 숫자, 특수문자 포함 8-15자로 입력해주세요."
        public static let passwordNotAccord = "비밀번호가 일치하지 않습니다."
        public static let signUpComplete = "가입 완료"
        public static let welcome = "SOPTAMP에 오신 것을 환영합니다"
        public static let start = "시작하기"
    }
    
    public struct ListDetail {
        public static let imagePlaceHolder = "달성 사진을 올려주세요"
        public static let memoPlaceHolder = "메모를 작성해주세요"
        public static let mission = "미션"
        public static let missionComplete = "미션 완료"
        public static let editComplete = "수정 완료"
        public static let editCompletedToast = "수정 완료되었습니다."
        public static let deleteTitle = "달성한 미션을 삭제하시겠습니까?"
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
        public static let resetMission = "미션 초기화"
        public static let logout = "로그아웃"
        public static let withdraw = "탈퇴하기"
        public static let passwordEditSuccess = "비밀번호가 변경되었습니다."
        public static let passwordEditFail = "비밀번호 변경 실패"
    }
}
