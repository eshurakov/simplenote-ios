import XCTest
@testable import Simplenote

// MARK: - SPHistoryLoaderTests
//
class SPHistoryLoaderTests: XCTestCase {

    /// Mockup versions fetcher
    ///
    private lazy var versionsFetcher = MockupVersionsFetcher()

    /// Test that empty result is returned and no fetch requests are made if current version is 0
    ///
    func testResultIsEmptyWhenCurrentVersionIsZero() throws {
        let historyLoader = SPHistoryLoader(versionsFetcher: versionsFetcher,
                                            simperiumKey: "",
                                            currentVersion: 0)
        var receivedItems: [SPHistoryLoader.Item]?
        historyLoader.load { (items) in
            receivedItems = items
        }

        XCTAssertEqual(receivedItems, [])
        XCTAssertEqual(versionsFetcher.requests, [])
    }

    /// Test that fetch request is sent with correct parameters
    ///
    func testFetchRequestIsSent() throws {
        let simperiumKey = UUID().uuidString
        let currentVersion = 5
        let historyLoader = SPHistoryLoader(versionsFetcher: versionsFetcher,
                                            simperiumKey: simperiumKey,
                                            currentVersion: currentVersion)

        historyLoader.load { (_) in

        }

        XCTAssertEqual(versionsFetcher.requests, [MockupVersionsFetcher.Request(numVersions: Int32(currentVersion),
                                                                              simperiumKey: simperiumKey)])
    }

    /// Test that returned items are sorted by version
    ///
    func testResultItemsAreSortedByVersion() throws {
        let currentVersion = 5
        let historyLoader = SPHistoryLoader(versionsFetcher: versionsFetcher,
                                            simperiumKey: UUID().uuidString,
                                            currentVersion: currentVersion)

        var receivedItems: [SPHistoryLoader.Item]?
        historyLoader.load { (items) in
            receivedItems = items
        }

        let versions: [Int] = (1...currentVersion).reversed()
        var expectedItems = historyLoader.processSampleData(forVersions: versions)
        expectedItems.sort(by: { $0.version < $1.version })

        XCTAssertEqual(receivedItems, expectedItems)
    }
}

// MARK: - Helper to send sample data to history loader
//
extension SPHistoryLoader {
    func processSampleData(forVersions versions: [Int]) -> [SPHistoryLoader.Item] {
        var result: [SPHistoryLoader.Item] = []

        for i in versions {
            let modificationTimeInterval = round(Date().timeIntervalSince1970 - TimeInterval.random(in: 0...9999))
            let content = UUID().uuidString

            let item = SPHistoryLoader.Item(version: i,
                                            modificationDate: Date(timeIntervalSince1970: modificationTimeInterval),
                                            content: content)
            result.append(item)

            let data: [String: Any] = [
                "modificationDate": modificationTimeInterval,
                "content": content
            ]
            process(data: data, forVersion: i)
        }

        return result
    }
}
