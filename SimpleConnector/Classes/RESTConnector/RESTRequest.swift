
open class RESTRequest: HTTPRequest {
    
    // MARK: Override
    override internal func getURLRequest(forConnector connector: HTTPConnector) -> URLRequest? {
        
        additionalHeaders["Accept"] = "application/json"
        additionalHeaders["Content-Type"] = "application/json"
        
        return super.getURLRequest(forConnector: connector)
    }
}

open class RESTCodableRequest<T: Encodable>: RESTRequest {
    
    // MARK: - Properties
    open var bodyObject: T? = nil {
        didSet {
            let jsonEncoder = JSONEncoder()
            if let jsonData = (try? jsonEncoder.encode(bodyObject)) {
                bodyData = jsonData
            }
        }
    }
    
    // MARK: Contructors
    public init(endPoint: String                    = "",
                method: HTTPMethod                  = .get,
                bodyObject: T?                      = nil,
                additionalHeaders: [String: String] = [:],
                gzipContent: Bool                   = false,
                timeoutInterval: TimeInterval?      = nil) {
        super.init(endPoint: endPoint,
                   method: method,
                   additionalHeaders: additionalHeaders,
                   gzipContent: gzipContent,
                   timeoutInterval: timeoutInterval)
        setBodyObject(bodyObject: bodyObject)
    }
    func setBodyObject(bodyObject: T?) {
        self.bodyObject = bodyObject
    }
}
