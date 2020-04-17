
open class RESTConnector {
    
    // MARK: - Properties
    private let httpConnector = HTTPConnector()
    open var baseURL: String {
        get { httpConnector.baseURL }
        set { httpConnector.baseURL = newValue }
    }
    open var timeoutInterval: TimeInterval {
        get { httpConnector.timeoutInterval }
        set { httpConnector.timeoutInterval = newValue }
    }
    @objc open var pinningCertificates: [HTTPPinningCertificate] {
        get { httpConnector.pinningCertificates }
        set { httpConnector.pinningCertificates = newValue }
    }
    
    // MARK: - Constructor
    public init(baseURL: String = "",
                timeoutInterval: TimeInterval = 60.0,
                pinningCertificates: [HTTPPinningCertificate] = []) {
        self.baseURL = baseURL
        self.timeoutInterval = timeoutInterval
        self.pinningCertificates = pinningCertificates
    }
    
    // MARK: - Requests
    open func request<IN, OUT>(codableRequest restRequest: RESTCodableRequest<IN>,
                               completion: @escaping ((RESTResponse<OUT>) -> Void)) {
        request(restRequest, completion: completion)
    }
    
    open func request<OUT>(_ restRequest: RESTRequest,
                           completion: @escaping ((RESTResponse<OUT>) -> Void)) {
        
        httpConnector.request(restRequest) { (httpResponse) in
            let response = RESTResponse<OUT>(data: httpResponse.data,
                                             urlResponse: httpResponse.urlResponse,
                                             error: httpResponse.error)
            completion(response)
        }
    }
}
