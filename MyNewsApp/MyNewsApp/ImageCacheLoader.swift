//
//  ImageCacheLoader.swift
//  MyNewsApp
//
//  Created by mhaashim on 19/03/25.
//

import SwiftUI

// ImageLoader to cache images
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    func loadImage(from urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        
        if let cachedImage = ImageCache.shared.get(forKey: urlString) {
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    ImageCache.shared.set(uiImage, forKey: urlString)
                    self.image = uiImage
                }
            }
        }
    }
}

// Simple Image Cache
class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
