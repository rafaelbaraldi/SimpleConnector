 
 open class HTTPConnector: NSObject {
    
    // MARK: - Properties
    open var baseURL: String = ""
    open var timeoutInterval: TimeInterval = 60.0
    open var pinningCertificates: [HTTPPinningCertificate] = []
    
    // MARK: - Constructor
    public init(baseURL: String = "",
                timeoutInterval: TimeInterval = 60.0,
                pinningCertificates: [HTTPPinningCertificate] = []) {
        self.baseURL = baseURL
        self.timeoutInterval = timeoutInterval
        self.pinningCertificates = pinningCertificates
    }
    
    // MARK: - Session
    lazy var session: URLSession = {
        return URLSession(configuration: .default,
                          delegate: self,
                          delegateQueue: nil)
    }()
    deinit {
        session.invalidateAndCancel()
    }
    
    // MARK: - Requests
    open func request(_ httpRequest: HTTPRequest,
                            completion: @escaping ((HTTPResponse) -> Void)) {
        
        guard let request = httpRequest.getURLRequest(forConnector: self) else {
            completion(HTTPResponse(error: HTTPRequestInvalidURLError()))
            return
        }
        
        let dataTask = session.dataTask(with: request) { (data, urlResponse, error) in
            let response = HTTPResponse(data: data,
                                        urlResponse: urlResponse,
                                        error: error)
            completion(response)
        }
        dataTask.resume()
    }
    open func requestImage(_ httpRequest: HTTPRequest,
                                 completion: @escaping ((ImageResponse) -> Void)) {
        request(httpRequest) { completion(ImageResponse(httpResponse: $0)) }
    }
 }

 // MARK: - URLSessionDelegate Pinning
 extension HTTPConnector: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession,
                           didReceive challenge: URLAuthenticationChallenge,
                           completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
            return
        }
        
        let certificateList = pinningCertificates.compactMap { return $0.getCertificate() }
        if certificateList.count <= 0 {
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
            return
        }
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if canTrustCertificates(serverTrust: serverTrust, certificateList: certificateList) {
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
                return
            }
        }
        completionHandler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
    
    private func canTrustCertificates(serverTrust: SecTrust, certificateList: [SecCertificate]) -> Bool {
        
        // Establish a chain of trust anchored on our bundled certificate.
        SecTrustSetAnchorCertificates(serverTrust, certificateList as NSArray)
        
        // Verify that trust
        var result = SecTrustResultType.invalid
        SecTrustEvaluate(serverTrust, &result)
        
        // @felipe a documentação da apple fala pra aceitar unspecified e proceed
        // https://developer.apple.com/reference/security/1394363-sectrustevaluate
        return ((result == SecTrustResultType.unspecified) || (result == SecTrustResultType.proceed))
    }
 }
