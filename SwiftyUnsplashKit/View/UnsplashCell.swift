//
//  UnsplashCellCollectionViewCell.swift
//  UnsplashTest
//
//  Created by Ever Uribe on 8/23/19.
//  Copyright © 2019 Ever Uribe. All rights reserved.
//

import UIKit

class UnsplashCell: UICollectionViewCell {
    
    var unsplashImageInfo: UnsplashImageInfo? {
        didSet {
            let url = URL(string: unsplashImageInfo!.imageUrl)
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data!)
                    self.authorLabel.text = self.unsplashImageInfo?.userName
                    self.authorLabel.isHidden = false
                }
            }
        }
    }
    
    let imageView: UIImageView = UIImageView()
    
    let authorButton: UIButton = {
        let button: UIButton = UIButton()
        return button
    }()
    
    let authorLabel: UITextField = {
        let label: UITextField = UITextField()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = bounds.height*0.05
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.clipsToBounds = true
        self.contentView.isUserInteractionEnabled = false
        
        authorButton.addTarget(self, action: #selector(openAuthorProfile), for: .touchUpInside)
        
        self.addSubview(imageView)
        self.addSubview(authorLabel)
        self.addSubview(authorButton)
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        authorLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        authorLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        authorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        authorButton.leftAnchor.constraint(equalTo: authorLabel.leftAnchor).isActive = true
        authorButton.rightAnchor.constraint(equalTo: authorLabel.rightAnchor).isActive = true
        authorButton.topAnchor.constraint(equalTo: authorLabel.topAnchor).isActive = true
        authorButton.bottomAnchor.constraint(equalTo: authorLabel.bottomAnchor).isActive = true
    }
    
    @objc private func openAuthorProfile(){
        print("DID TAP")
        if let info = unsplashImageInfo {
            guard let url = URL(string: info.userProfileLink) else { return }
            UIApplication.shared.open(url)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
