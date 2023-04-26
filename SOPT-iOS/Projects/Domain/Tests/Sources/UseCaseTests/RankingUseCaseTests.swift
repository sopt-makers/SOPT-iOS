
import XCTest
import Combine
import Core
@testable import Domain

final class DefaultRankingUseCaseTests: XCTestCase {
    private var useCase: DefaultRankingUseCase!
    private var repository: MockRankingRepository!

    override func setUp() {
        super.setUp()
        repository = MockRankingRepository()
        useCase = DefaultRankingUseCase(repository: repository)
    }

    override func tearDown() {
        useCase = nil
        repository = nil
        super.tearDown()
    }

    func test_fetchRankingList() {
        // Given
        let expectation = XCTestExpectation(description: "Fetching ranking list")

        let myUsername = "user2"
        var rankingModel = findRankingModel
        rankingModel[1].setMyRanking(true)
        repository.fetchRankingListModelResponse = .success(rankingModel)
        UserDefaultKeyList.User.soptampName = myUsername
        
        // When
        useCase.rankingListModelFetched
            .dropFirst()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
            } receiveValue: { model in
                // Then
                XCTAssertEqual(model, rankingModel)
                expectation.fulfill()
            }
            .store(in: repository.cancelBag)

        useCase.fetchRankingList()

        wait(for: [expectation], timeout: 0.5)
    }
    
    func test_findMyRanking_index0() {
        // Given
        let expectation = XCTestExpectation(description: "Finding my ranking")
        
        let myUserName = "user1"
        UserDefaultKeyList.User.soptampName = myUserName
        repository.fetchRankingListModelResponse = .success(findRankingModel)
        
        // When
        useCase.myRanking
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
            } receiveValue: { (section, item) in
                // Then
                XCTAssertEqual(section, 0)
                XCTAssertEqual(item, 0)
                expectation.fulfill()
            }
            .store(in: repository.cancelBag)
        
        useCase.fetchRankingList()
        useCase.findMyRanking()
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func test_findMyRanking_index2() {
        // Given
        let expectation = XCTestExpectation(description: "Finding my ranking")
        
        let myUserName = "user3"
        UserDefaultKeyList.User.soptampName = myUserName
        repository.fetchRankingListModelResponse = .success(findRankingModel)
        
        // When
        useCase.myRanking
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
            } receiveValue: { (section, item) in
                // Then
                XCTAssertEqual(section, 0)
                XCTAssertEqual(item, 0)
                expectation.fulfill()
            }
            .store(in: repository.cancelBag)
        
        useCase.fetchRankingList()
        useCase.findMyRanking()
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func test_findMyRanking_indexOver3() {
        // Given
        let expectation = XCTestExpectation(description: "Finding my ranking")
        
        let myUserName = "user4"
        UserDefaultKeyList.User.soptampName = myUserName
        repository.fetchRankingListModelResponse = .success(findRankingModel)
        
        // When
        useCase.myRanking
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
            } receiveValue: { (section, item) in
                // Then
                XCTAssertEqual(section, 1)
                XCTAssertEqual(item, 0)
                expectation.fulfill()
            }
            .store(in: repository.cancelBag)
        
        useCase.fetchRankingList()
        useCase.findMyRanking()
        
        wait(for: [expectation], timeout: 0.5)
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
