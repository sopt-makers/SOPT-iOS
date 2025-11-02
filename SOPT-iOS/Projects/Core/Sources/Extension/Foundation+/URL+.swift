import Foundation

public extension URL {
    /// - Description: URL에 한국어가 있는 경우, 퍼센트 문자로 치환합니다
    static func decodeURL(urlString: String) -> URL? {
        if let url = URL(string: urlString) {
            return url
        } else {
            let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString
            return URL(string: encodedString)
        }
    }
    
    var rootDomain: String? {
        guard let host = self.host() else { return nil }
        let components = host.components(separatedBy: ".")
        
        guard components.count >= 2 else { return nil }
        return components.suffix(2).joined(separator: ".")
    }
}
