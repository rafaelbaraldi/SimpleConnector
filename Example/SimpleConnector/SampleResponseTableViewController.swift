//
//  SampleResponseTableViewController.swift
//  SimpleConnector_Example
//
//  Created by Rafael Baraldi on 16/04/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

// MARK: - Display Response Controllers
class SampleResponseTableViewController: UIViewController {
    
    // MARK: - Views
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .center
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var textView: UITextView = {
        let image = UITextView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    // MARK: Constructors
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = image
        setupView(imageView)
    }
    init(text: String) {
        super.init(nibName: nil, bundle: nil)
        textView.text = text
        setupView(textView)
    }
    init<T: Encodable>(object: T) {
        super.init(nibName: nil, bundle: nil)
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(object),
            let text = String(data: jsonData, encoding: .utf8) {
            textView.text = text
            setupView(textView)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Setup
    private func setupView(_ addingView: UIView) {
        view.backgroundColor = .white
        view.addSubview(addingView)
        let topConstraint = addingView.topAnchor.constraint(equalTo: view.topAnchor)
        let leadingConstraint = addingView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let bottomConstraint = addingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let trailingConstraint = addingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        view.addConstraints([topConstraint, leadingConstraint, bottomConstraint, trailingConstraint])
    }
}
