//
//  StringLiterals.swift
//  Core
//
//  Created by 양수빈 on 2022/10/06.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Foundation

public struct I18N {
    public struct Sample {
        public static let error = "에러"
        public static let networkError = "네트워크 오류가 발생했습니다."
    }
    
    public struct TextFieldView {
        public static let verify = "확인"
    }
    
    public struct Navi {
        public static let post = "공지"
    }
    
    public struct Search {
        public static let placeholder = "검색어 입력"
        public static let cancel = "취소"
        public static let countUnit = " 건"
        public static let enterSearch = "검색어를 입력해 주세요."
        public static let noSearchData = "등록된 게시물이 없습니다"
    }
    
    public struct SignUp {
        public static let signUp = "회원가입"
        public static let nickname = "닉네임"
        public static let nicknameTextFieldPlaceholder = "한글/영문 NN자로 입력해주세요."
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
}
