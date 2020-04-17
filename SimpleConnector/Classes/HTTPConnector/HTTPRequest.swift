
open class HTTPRequest {
    
    // MARK: - Properties
    open var endPoint: String                    = ""
    open var method: HTTPMethod                  = .get
    open var bodyData: Data?                     = nil
    open var additionalHeaders: [String: String] = [:]
    open var gzipContent: Bool                   = false
    open var timeoutInterval: TimeInterval?      = nil
    
    // MARK: - Constructors
    public init(endPoint: String                    = "",
                method: HTTPMethod                  = .get,
                bodyData: Data?                     = nil,
                additionalHeaders: [String: String] = [:],
                gzipContent: Bool                   = false,
                timeoutInterval: TimeInterval?      = nil) {
        self.endPoint = endPoint
        self.method = method
        self.bodyData = bodyData
        self.additionalHeaders = additionalHeaders
        self.gzipContent = gzipContent
        self.timeoutInterval = timeoutInterval
    }
    
    // MARK: - Converter
    internal func getURLRequest(forConnector connector: HTTPConnector) -> URLRequest? {
        
        guard let url = URL(string: "\(connector.baseURL)\(endPoint)") else {
            return nil
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval ?? connector.timeoutInterval
        request.httpBody = bodyData
        
        additionalHeaders.forEach({ request.addValue($1, forHTTPHeaderField: $0) })
        
        if gzipContent {
            request.addValue("gzip", forHTTPHeaderField: "Content-Encoding")
            request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        }
        
//        if contentType ?? false && encoding ?? false {
//            request.addValue(contentType + ";" + encoding, forHTTPHeaderField: "Content-Type")
//        }
        
        return request
    }
}

// MARK: - Request Errors
struct HTTPRequestInvalidURLError: Error {
    var errorDescription: String? = "Invalid request"
}
