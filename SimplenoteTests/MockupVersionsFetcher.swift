import Foundation
@testable import Simplenote

// MARK: - MockupVersionsFetcher
//
class MockupVersionsFetcher: VersionsFetcher {
    struct Request: Equatable {
        let numVersions: Int32
        let simperiumKey: String
    }

    /// Store requests so that we can check them from tests
    ///
    var requests: [Request] = []

    func requestVersions(_ numVersions: Int32, key simperiumKey: String!) {
        requests.append(Request(numVersions: numVersions,
                                simperiumKey: simperiumKey))
    }
}
