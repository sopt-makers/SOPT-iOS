//
//  RankingRepository.swift
//  Presentation
//
//  Created by Junho Lee on 2022/12/04.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import Combine

import Core
import Domain
import Network

public class RankingRepository {
    
    private let networkService: RankService
    private let cancelBag = CancelBag()
    
    public init(service: RankService) {
        self.networkService = service
    }
}

extension RankingRepository: RankingRepositoryInterface {
    public func fetchRankingListModel() -> AnyPublisher<[Domain.RankingModel], Error> {
        return Future<[RankingModel], Error> { promise in
            promise(.success([RankingModel.init(username: "1등이다", usreId: 1, score: 94, sentence: "제가 1등입니다"), RankingModel.init(username: "헬로", usreId: 2, score: 92, sentence: "2등"), RankingModel.init(username: "이름이 긴 사람", usreId: 3, score: 91, sentence: "제가 3등입니다 말이 길어지면 어케"), RankingModel.init(username: "더미데이름", usreId: 4, score: 86, sentence: "4444"), RankingModel.init(username: "레포지토리", usreId: 5, score: 65, sentence: "5"), RankingModel.init(username: "인터페이스", usreId: 6, score: 53, sentence: "ㅎㄴ마ㄷ한마디"), RankingModel.init(username: "솝트", usreId: 7, score: 53, sentence: "하남ㄴㅁㅇㄹㅁㅋㅌㅊㅍ"), RankingModel.init(username: "노가다", usreId: 8, score: 52, sentence: "한마디 띄우기"), RankingModel.init(username: "9등이다", usreId: 9, score: 40, sentence: "한마디 최고글자길이는몇일까여?"), RankingModel.init(username: "10등이다", usreId: 10, score: 35, sentence: "5166"), RankingModel.init(username: "11등이다", usreId: 11, score: 32, sentence: "더메대충이데머"), RankingModel.init(username: "12등이다", usreId: 12, score: 12, sentence: "대충 더미데잍"), RankingModel.init(username: "안녕하세요", usreId: 13, score: 7, sentence: "531542642"), RankingModel.init(username: "14등이다", usreId: 14, score: 5, sentence: "한마디 귀찮아"), RankingModel.init(username: "15등이다", usreId: 15, score: 3, sentence: "")]))
        }.eraseToAnyPublisher()
    }
}
