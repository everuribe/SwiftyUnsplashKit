//
//  UnsplashSearchPresenter.swift
//  UnsplashTest
//
//  Created by Ever Uribe on 8/23/19.
//  Copyright © 2019 Ever Uribe. All rights reserved.
//

import UIKit


var unsplashResults: [UIImage] = []

///Class that handles displaying UnsplashSearchPickerView object as a modular controller using the application's keyWindow.
public class UnsplashSearchPresenter: NSObject {
    public var delegate: UnsplashPickerDelegate?
    
    private let keywords: String
    private let accessKey: String
    
    private var unsplashView: UnsplashSearchPickerView!
    
    ///Reference to top constraint of unsplashView for pan gesture sliding
    private var topConstraint: NSLayoutConstraint!
    
    ///Reference to key window
    private var keyWindow: UIWindow!

    ///- parameter initialSearchTerms: Keyword(s) used for image search in initial UnsplashSearchPickerView presentation. For multiple keywords, separate with commas, no spaces.
    ///- parameter accessKey: The developer access key provided by Unsplash API for a specific developer and application.
    init(initialSearchTerms: String, accessKey: String){
        self.keywords = initialSearchTerms
        self.accessKey = accessKey
    }
    
    ///Opens the unsplash view.
    public func openUnsplashView() {
        if let keyWindowRef: UIWindow = UIApplication.shared.keyWindow {
            keyWindow = keyWindowRef
            
            unsplashView = UnsplashSearchPickerView(presenter: self, initialKeywords: keywords, accessKey: accessKey)
            unsplashView.layer.cornerRadius = 10
            unsplashView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            unsplashView.clipsToBounds = true
            
            let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
            unsplashView.addGestureRecognizer(panGesture)
            
            keyWindow.addSubview(unsplashView)
            
            //x,y,w,h
            unsplashView.translatesAutoresizingMaskIntoConstraints = false
            
            unsplashView.leftAnchor.constraint(equalTo: keyWindow.leftAnchor).isActive = true
            unsplashView.rightAnchor.constraint(equalTo: keyWindow.rightAnchor).isActive = true
            unsplashView.heightAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.heightAnchor, constant: keyWindow.safeAreaInsets.bottom).isActive = true
            topConstraint = unsplashView.topAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.topAnchor, constant: keyWindow.frame.height)
            topConstraint.isActive = true
            
            //Establish start point
            keyWindow.layoutIfNeeded()
            
            //Animate view into display
            topConstraint.constant = 0
            UIView.animate(withDuration: 0.55, animations: {
                self.keyWindow.layoutIfNeeded()
            })
        }
    }
    
    ///Closes the unsplash view
    func closeUnsplashView() {
        topConstraint.constant = keyWindow.frame.height
        
        UIView.animate(withDuration: 0.25, animations: {
            self.keyWindow.layoutIfNeeded()
        }, completion: { completion in
            self.unsplashView.removeFromSuperview()
            self.unsplashView = nil
            self.topConstraint = nil
            self.keyWindow = nil
        })
    }
    
    
    ///Handles dragging to close the unsplash view.
    @objc private func handlePanGesture(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: keyWindow)
        if translation.y >= 0 {
            slideViewTo(location: translation.y)
        } else if translation.y < 0 && topConstraint.constant != 0 {
            slideViewTo(location: 0)
        }
        
        if pan.state == .began {
            if unsplashView.searchBar.text!.isEmpty {
                unsplashView.cancelSearch()
            } else {
                unsplashView.searchBar.endEditing(true)
            }
        } else if pan.state == .ended {
            slideViewFrom(finalLocation: translation.y)
        }
    }
    
    ///Handles movement of unsplash view as it's sliding.
    func slideViewTo(location: CGFloat){
        topConstraint.constant = location
        keyWindow.layoutIfNeeded()
    }
    
    ///Handles final action on unsplash view after sliding is completed: close view or return to original position.
    func slideViewFrom(finalLocation: CGFloat){
        unsplashView.isUserInteractionEnabled = false
        if finalLocation > 60 {
            closeUnsplashView()
        } else {
            topConstraint.constant = 0
            
            UIView.animate(withDuration: 0.25, animations: {
                self.keyWindow.layoutIfNeeded()
            }, completion: { completion in
                self.unsplashView.isUserInteractionEnabled = true
            })
        }
    }
}
