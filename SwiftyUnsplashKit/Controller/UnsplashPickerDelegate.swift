//
//  UnsplashPresenterDelegate.swift
//  UnsplashTest
//
//  Created by Ever Uribe on 8/27/19.
//  Copyright © 2019 Ever Uribe. All rights reserved.
//

import Foundation
import UIKit

public protocol UnsplashPickerDelegate {
    func handleUnsplashImageSelected(image: UIImage, url: String)
}
