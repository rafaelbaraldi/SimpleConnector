 
 open class HTTPResponse {
    
    // MARK: - Properties
    open var data: Data?
    open var urlResponse: URLResponse?
    open var error: Error?
    
    // MARK: - Constructors
    public init(data: Data? = nil,
                urlResponse: URLResponse? = nil,
                error: Error? = nil) {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }
 }
 
 open class ImageResponse: HTTPResponse {
    
    // MARK: - Properties
    open lazy var image: UIImage? = {
        guard let data = data else { return nil }
        return UIImage(data: data)
    }()
    
    // MARK: - Constructors
    public init(httpResponse: HTTPResponse) {
        super.init(data: httpResponse.data,
                   urlResponse: httpResponse.urlResponse,
                   error: httpResponse.error)
    }
 }
