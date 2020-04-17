//
//  SampleListTableViewController.swift
//  HTTPConnector_Example
//
//  Created by Rafael Baraldi on 18/02/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SimpleConnector

struct TestAction {
    let title: String
    let action: (() -> (Void))
}

class SampleListTableViewController: UITableViewController {

    // MARK: - Views
    private lazy var loadingView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        return spinner
    }()
    
    // MARK: - Properties
    let optionCellIdentifier = "optionCell"
    
    lazy var testList = [
        TestAction(title: "Get HTTP Request", action: getRequestAction),
        TestAction(title: "Image HTTP Request", action: imageRequestAction),
        TestAction(title: "REST Request", action: restRequestAction)
    ]

    // MARK: Constructors
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Simple Connector"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: optionCellIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Displayables
    func display(error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        
        let alertAction = UIAlertAction.init(title: "Ok", style: .default)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true)
    }
}

// MARK: - Table View
extension SampleListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: optionCellIdentifier,
                                                 for: indexPath)
        cell.textLabel?.text = testList[indexPath.row].title
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        testList[indexPath.row].action()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Actions
extension SampleListTableViewController {
    
    func getRequestAction() {
        let request = HTTPRequest()
        request.endPoint = "https://www.github.com"
        request.method   = .get
        
        let connector = HTTPConnector()
        connector.pinningCertificates.append(HTTPPinningCertificate(path: "RaizGithubPinning.cer"))
        connector.pinningCertificates.append(HTTPPinningCertificate(path: "MeioGithubPinning.cer"))
        connector.pinningCertificates.append(HTTPPinningCertificate(path: "PontaGithubPinning.cer"))

        connector.pinningCertificates.append(HTTPPinningCertificate(path: "RaizUOLPinning.cer"))
        connector.pinningCertificates.append(HTTPPinningCertificate(path: "MeioUOLPinning.cer"))
        
        loadingView.startAnimating()
        connector.request(request) { (response) in
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                if let error = response.error {
                    self.display(error: error)
                    return
                }
                guard let data = response.data,
                    let text = String(data: data, encoding: .utf8) else {
                        self.display(error: SampleError())
                        return
                }
                let responseViewController = SampleResponseTableViewController(text: text)
                self.navigationController?.pushViewController(responseViewController, animated: true)
            }
        }
    }
    
    func imageRequestAction() {
        let request = HTTPRequest()
        request.endPoint = "https://github.githubassets.com/images/modules/site/logos/swift-logo.png"
        request.method   = .get
        
        let connector = HTTPConnector()
        
        loadingView.startAnimating()
        connector.requestImage(request) { (response) in
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                if let error = response.error {
                    self.display(error: error)
                    return
                }
                guard let image = response.image else {
                    self.display(error: SampleError())
                    return
                }
                let responseViewController = SampleResponseTableViewController(image: image)
                self.navigationController?.pushViewController(responseViewController, animated: true)
            }
        }
    }
    
    func restRequestAction() {
        let request = RESTCodableRequest(endPoint: "/users",
                                         method: .post,
                                         bodyObject: User())
        
        let connector = RESTConnector(baseURL: "https://reqres.in/api")
        
        loadingView.startAnimating()
        connector.request(codableRequest: request) { (response: RESTResponse<User>) in
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                if let error = response.error {
                    self.display(error: error)
                    return
                }
                guard let user = response.object else {
                        self.display(error: SampleError())
                        return
                }
                let responseViewController = SampleResponseTableViewController(object: user)
                self.navigationController?.pushViewController(responseViewController, animated: true)
            }
        }
    }
}

// MARK: - Error
struct SampleError: LocalizedError {
    var errorDescription: String? = "Invalid response"
}

// MARK: - Models
struct User: Codable {
    var name: String? = "Pedro"
    var job: String? = "programador"
}
