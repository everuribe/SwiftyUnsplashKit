//
//  UnsplashSearchView.swift
//  UnsplashTest
//
//  Created by Ever Uribe on 8/23/19.
//  Copyright © 2019 Ever Uribe. All rights reserved.
//

import UIKit

///Search view comprising of search bar and collection view that displays Unsplash results. If no search exists, the initialKeywords are used to determine what will be shown.
class UnsplashSearchPickerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    let unsplashAccessKey: String
    let initialKeywords: String
    
    private var unsplashResults: [UnsplashImageInfo] = []
    private let reuseIdentifier: String = "unsplashImage"
    private let presenter: UnsplashSearchPresenter

    private let blurEffect: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private let collectionView = UnsplashCollectionView(cellWidth: 160, spaceBetweenCells: 10)
    
    private let headerButton: UIButton = {
        let button: UIButton = UIButton()
        button.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
        button.setImage(scrollHeaderIcon, for: .normal)
        button.setImage(scrollHeaderSelectedIcon, for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    ///Variable dictating whether collectionView section title 'TRENDING GIFS' is visible
    private var showHeader: Bool = true
    
    let searchBar: SearchBar = SearchBar(textColor: .white, placeholderText: NSAttributedString(string: "Search Unsplash", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]), backgroundColor: .lightGray)
    
    private var searchBarRightConstraint: NSLayoutConstraint!
    
    private let searchCancelButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(resetSearch), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private static var scrollHeaderIcon: UIImage {
        let bundle = Bundle(for: self)
        let image: UIImage = UIImage(named: "scroll_header", in: bundle, compatibleWith: nil)!
        return image
    }
    
    private static var scrollHeaderSelectedIcon: UIImage {
        let bundle = Bundle(for: self)
        let image: UIImage = UIImage(named: "scroll_header_selected", in: bundle, compatibleWith: nil)!
        return image
    }
    
    //MARK: VIEW SETUP
    ///- parameter presenter: Reference to presenter to access method used to close view. 
    ///- parameter initialKeywords: Keyword(s) used for image search in initial UnsplashSearchPickerView presentation. For multiple keywords, separate with commas, no spaces.
    ///- parameter accessKey: The developer access key provided by Unsplash API for a specific developer and application.
    init(presenter: UnsplashSearchPresenter, initialKeywords: String, accessKey: String) {
        self.presenter = presenter
        self.initialKeywords = initialKeywords
        self.unsplashAccessKey = accessKey
        
        super.init(frame: .zero)
        
        //Set trending unsplash
        let unsplashDefaultUrl: String = "https://api.unsplash.com/search/photos?page=1&per_page=40&query=\(initialKeywords)"
        downloadJSON(searchUrl: unsplashDefaultUrl)
        
        addSubview(blurEffect)
        addSubview(headerButton)
        
        //Configure search bar
        searchBar.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchBar.delegate = self
        searchBar.layer.cornerRadius = 10
        addSubview(searchBar)
        
        addSubview(searchCancelButton)
        
        //Configure collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UnsplashCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        
        //Configure panGesture
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGesture.delegate = self
        collectionView.addGestureRecognizer(panGesture)
        
        addSubview(collectionView)
        setConstraints()
    }
    
    ///Set view auto layout + constraints
    private func setConstraints() {
        blurEffect.translatesAutoresizingMaskIntoConstraints = false
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchCancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        blurEffect.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        blurEffect.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        blurEffect.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        blurEffect.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        headerButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        headerButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        headerButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        searchBar.topAnchor.constraint(equalTo: headerButton.bottomAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        searchBarRightConstraint = searchBar.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20)
        searchBarRightConstraint.isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        searchCancelButton.topAnchor.constraint(equalTo: searchBar.topAnchor).isActive = true
        searchCancelButton.leftAnchor.constraint(equalTo: searchBar.rightAnchor).isActive = true
        searchCancelButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        searchCancelButton.heightAnchor.constraint(equalTo: searchBar.heightAnchor).isActive = true
        
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    ///Moves search bar + cancel button when search is toggled
    private func toggleSearchAnimation(shouldReveal: Bool){
        if shouldReveal {
            searchBarRightConstraint.constant = -90
            
            UIView.animate(withDuration: 0.25, animations: {
                self.layoutIfNeeded()
            }, completion: {completion in
                self.searchCancelButton.isEnabled = true
            })
        } else {
            searchBarRightConstraint.constant = -20
            
            UIView.animate(withDuration: 0.25, animations: {
                self.layoutIfNeeded()
            }, completion: {completion in
                self.searchCancelButton.isEnabled = false
            })
        }
    }
    
    //MARK: DATA DOWNLOAD
    private func downloadJSON(searchUrl: String) {
        guard let jsonUrl: URL = URL(string: searchUrl) else {return}
        
        var urlRequest = URLRequest(url: jsonUrl)
        urlRequest.setValue("Client-ID \(unsplashAccessKey)", forHTTPHeaderField: "Authorization")
                
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, urlResponse, error) in
            guard let data = data else {
                if let response = urlResponse {
                    print("Failed to download images: \(response)")
                }
                return
            }
            do {
                let searchObject: UnsplashArrayObject = try JSONDecoder().decode(UnsplashArrayObject.self, from: data)
                DispatchQueue.main.async {
                    self.unsplashResults = searchObject.unsplashImagesInfo
                    self.collectionView.reloadData()
                }
            } catch {
                print(error)
            }
        }).resume()
    }
    
    var timer: Timer?
    
    private func fetchJSONOnTimer(urlString: String) {
        cancelTimer()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { (timer) in
            self.downloadJSON(searchUrl: urlString)
        })
    }
    
    private func cancelTimer(){
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    //MARK: USER INTERACTION METHODS
    @objc private func scrollToTop() {
        cancelSearch()
        
        if collectionView.contentOffset != .zero {
            collectionView.setContentOffset(.zero, animated: true)
        } else {
            presenter.closeUnsplashView()
        }
    }
    
    //Handle pan if user is sliding opposite of scrollview when scrolled to top.
    @objc private func handlePan(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: self)
        if translation.y > 0 {
            presenter.slideViewTo(location: translation.y)
            
            if pan.state == .ended {
                presenter.slideViewFrom(finalLocation: translation.y)
            }
        }
    }
    
    @objc private func resetSearch(){
        cancelSearch()
        let unsplashDefaultUrl: String = "https://api.unsplash.com/search/photos?page=1&per_page=40&query=\(initialKeywords)"
        downloadJSON(searchUrl: unsplashDefaultUrl)
    }
    
    func cancelSearch(){
        cancelTimer()
        toggleSearchAnimation(shouldReveal: false)
        searchBar.toggleSearch(didBeganEditing: false)
        searchBar.endEditing(true)
        searchBar.text = ""
        showHeader = true
    }
    
    //MARK: COLLECTIONVIEW DELEGATES
    
    //If gif is selected, deselect, find the delegate handling it's use, let delegate handle, and tell presenter to close this view.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let delegate: UnsplashPickerDelegate = presenter.delegate {
            let cell: UnsplashCell = collectionView.cellForItem(at: indexPath) as! UnsplashCell
            
            if let selectedImage: UIImage = cell.imageView.image, let url: String = cell.unsplashImageInfo?.imageUrl {
                delegate.handleUnsplashImageSelected(image: selectedImage, url: url)
                presenter.closeUnsplashView()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsplashResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UnsplashCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UnsplashCell
        
        // Configure the cell
        cell.unsplashImageInfo = unsplashResults[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            sectionHeader.label.text = "EVENT PHOTOS"
            sectionHeader.label.textColor = .black
            return sectionHeader
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if showHeader {
            return CGSize(width: collectionView.frame.width, height: 30)
        } else {
            return .zero
        }
    }
    
    // MARK: TEXTFIELD DELEGATE
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            searchBar.toggleSearch(didBeganEditing: true)
            toggleSearchAnimation(shouldReveal: true)
            showHeader = false
        }
    }
    
    ///Called whenever the text in the search bar changes.
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.isEmpty {
            showHeader = true
            let unsplashDefaultUrl: String = "https://api.unsplash.com/search/photos?page=1&per_page=40&query=\(initialKeywords)"
            
            fetchJSONOnTimer(urlString: unsplashDefaultUrl)
            //downloadJSON(searchUrl: unsplashDefaultUrl)
        } else {
            showHeader = false
            let keywords: String = textField.text!.replacingOccurrences(of: " ", with: ",")
            
            let searchURL: String = "https://api.unsplash.com/search/photos?page=1&per_page=40&query=\(keywords)"
            
            fetchJSONOnTimer(urlString: searchURL)
//            downloadJSON(searchUrl: searchURL)
        }
    }
    
    //MARK: SCROLLVIEW DELEGATE
    //Close search or just the keyboard depending on if searchBar contains text.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if searchBar.text!.isEmpty {
            cancelSearch()
        } else {
            searchBar.endEditing(true)
        }
    }
    
    //Disable bouncing if final position is at top
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset == .zero {
            collectionView.bounces = false
        }
    }
    
    //Enable bouncing if began scrolling and not at contentOffset of zero
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset != .zero {
            collectionView.bounces = true
        } else {
            collectionView.bounces = false
        }
    }
    
    //MARK: GESTURERECOGNIZER DELEGATE
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return collectionView.contentOffset.y == 0
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: MISC
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

