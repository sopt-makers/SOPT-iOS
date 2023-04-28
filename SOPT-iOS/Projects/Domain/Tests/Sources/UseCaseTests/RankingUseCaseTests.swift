@testable import Domain

import XCTest
import Combine
import Core
import Nimble
import Quick

final
class DefaultRankingUseCaseTests: QuickSpec {
    override func spec() {
        describe("DefaultRankingUseCase") {
            var useCase: DefaultRankingUseCase!
            var repository: MockRankingRepository!
            
            beforeEach {
                repository = MockRankingRepository()
                useCase = DefaultRankingUseCase(repository: repository)
            }
            
            afterEach {
                useCase = nil
                repository = nil
            }
            
            context("fetchRankingList") {
                it("랭킹 리스트 및 내 래킹 유무를 가져옴") {
                    // Given
                    let myUsername = "user2"
                    var rankingModel = self.findRankingModel
                    rankingModel[1].setMyRanking(true)
                    repository.fetchRankingListModelResponse = .success(rankingModel)
                    UserDefaultKeyList.User.soptampName = myUsername
                    
                    // When
                    useCase.fetchRankingList()
                    
                    // Then
                    expect(useCase.rankingListModelFetched.value).toEventually(equal(rankingModel))
                }
            }
            
            context("findMyRanking") {
                context("myUsername의 인덱스가 4 미만이면") {
                    it("(0, 0) 반환") {
                        // Given
                        let myUsername = "user3"
                        let rankingModel = self.findRankingModel
                        repository.fetchRankingListModelResponse = .success(rankingModel)
                        UserDefaultKeyList.User.soptampName = myUsername
                        useCase.rankingListModelFetched.send(rankingModel)
                        
                        // When
                        defer { useCase.findMyRanking() }
                        
                        // Then
                        useCase.myRanking
                            .sink(
                                receiveCompletion: { completion in
                                    switch completion {
                                    case .finished:
                                        break
                                    case .failure(let error):
                                        fail("Error: \(error)")
                                    }
                                },
                                receiveValue: { section, item in
                                    expect(section).to(equal(0))
                                    expect(item).to(equal(0))
                                }
                            ).store(in: repository.cancelBag)
                    }
                }
                
                context("myUsername의 인덱스가 4이면") {
                    it("(1, 0) 반환") {
                        // Given
                        let myUsername = "user4"
                        let rankingModel = self.findRankingModel
                        repository.fetchRankingListModelResponse = .success(rankingModel)
                        UserDefaultKeyList.User.soptampName = myUsername
                        useCase.rankingListModelFetched.send(rankingModel)
                        
                        // When
                        defer { useCase.findMyRanking() }
                        
                        // Then
                        useCase.myRanking
                            .sink(
                                receiveCompletion: { completion in
                                    switch completion {
                                    case .finished:
                                        break
                                    case .failure(let error):
                                        fail("Error: \(error)")
                                    }
                                },
                                receiveValue: { section, item in
                                    expect(section).to(equal(1))
                                    expect(item).to(equal(0))
                                }
                            ).store(in: repository.cancelBag)
                    }
                }
                
                context("myUsername의 인덱스가 4 초과이면") {
                    it("section: 1, item: index - 3 반환") {
                        // Given
                        let myUsername = "user6"
                        let rankingModel = self.findRankingModel
                        repository.fetchRankingListModelResponse = .success(rankingModel)
                        UserDefaultKeyList.User.soptampName = myUsername
                        useCase.rankingListModelFetched.send(rankingModel)
                        
                        // When
                        defer { useCase.findMyRanking() }
                        
                        // Then
                        useCase.myRanking
                            .sink(
                                receiveCompletion: { completion in
                                    switch completion {
                                    case .finished:
                                        break
                                    case .failure(let error):
                                        fail("Error: \(error)")
                                    }
                                },
                                receiveValue: { section, item in
                                    expect(section).to(equal(1))
                                    expect(item).to(equal(2))
                                }
                            ).store(in: repository.cancelBag)
                    }
                }
            }
        }
    }
}

extension DefaultRankingUseCaseTests {
    var findRankingModel: [RankingModel] {
        return [
            RankingModel(username: "user1", score: 100, sentence: "Sentence1"),
            RankingModel(username: "user2", score: 90, sentence: "Sentence2"),
            RankingModel(username: "user3", score: 80, sentence: "Sentence3"),
            RankingModel(username: "user4", score: 70, sentence: "Sentence4"),
            RankingModel(username: "user5", score: 60, sentence: "Sentence5"),
            RankingModel(username: "user6", score: 60, sentence: "Sentence6"),
            RankingModel(username: "user7", score: 60, sentence: "Sentence7"),
        ]
    }
}
