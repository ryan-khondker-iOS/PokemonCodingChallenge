//
//  GlobalCache.swift
//  Pokemon
//
//  Created by Ryan on 7/26/21.
//

import UIKit

class GlobalCache {
    static let shared = GlobalCache()
    var imageCache = NSCache<NSString, UIImage>()
}
