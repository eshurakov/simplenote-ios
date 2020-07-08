import Foundation

// MARK: - VersionsFetcher: Request versions of Simperium object
//
protocol VersionsFetcher {
    func requestVersions(_ numVersions: Int32, key simperiumKey: String!)
}
