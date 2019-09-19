//
//  ViewController.swift
//  ExampleApp
//
//  Created by Ever Uribe on 9/16/19.
//  Copyright © 2019 Ever Uribe. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UnsplashPickerDelegate {
    func handleImageSelected(image: UIImage, url: String) {
        imageView.image = image
    }
    

    let button : UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(handleButtonAction), for: .touchUpInside)
        button.setTitle("Select Unsplash Image", for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    let presenter: UnsplashSearchPresenter = UnsplashSearchPresenter(initialSearchTerms: "event", accessKey: "9881a1c90c4719f8865ad7edff3eae45d7818ff27b84796c0a75cbd48c7b36b0")
    
    let imageView = UIImageView(image: UIImage(named: "choose_unsplash"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        // Set presenter delegate
        presenter.delegate = self
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        self.view.addSubview(imageView)
        self.view.addSubview(button)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 240).isActive = true
        button.layer.cornerRadius = 30
    }

    @objc func handleButtonAction() {
        presenter.openUnsplashView()
    }
}

