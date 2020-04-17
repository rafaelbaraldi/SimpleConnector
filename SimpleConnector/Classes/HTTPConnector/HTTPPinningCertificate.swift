//
//  HTTPPinningCertificate.swift
//  Autoparse
//
//  Created by Rafael Baraldi on 18/02/20.
//

@objc open class HTTPPinningCertificate: NSObject {
    
    // MARK: - Properties
    var filePath: String
    var fileBundle: Bundle = Bundle.main
    
    // MARK: - Constructors
    @objc public init(path: String, bundle: Bundle = Bundle.main) {
        filePath = path
        fileBundle = bundle
        super.init()
    }
    
    // MARK: - Getters
    func getCertificate() -> SecCertificate? {
        guard let certificateURL = fileBundle.url(forResource: self.filePath,
                                                  withExtension: nil),
            let certificateData = try? Data(contentsOf: certificateURL) else { return nil }
        return SecCertificateCreateWithData(nil, (certificateData as CFData))
    }
}
