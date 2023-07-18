//
//  ImageLoader.swift
//  AsyncAwaitIOS
//
//  Created by Rezaul Islam on 18/7/23.
//

import Foundation
import SwiftUI

final class ImageLoader: ObservableObject{
    @Published var image : Image? = nil
     
    func load(fromUrl url:String){
         downloadImage(from: url){ uiImage in
            guard let uiImage = uiImage else {
                return
            }
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
            }
        }
    }
    
}

struct RemoteImage: View {
    var image: Image?
    var body: some View{
        if let image = image {
                    image.resizable()
                } else {
                    Image(systemName: "photo")
                        .font(.system(size: 60)) // Increase the size here
                }
    }
}

struct UrlImageView : View {
    @StateObject private var imageLoader = ImageLoader()
    var urlString: String
    
    var body: some View{
        RemoteImage(image: imageLoader.image)
            .onAppear{
                imageLoader.load(fromUrl: urlString)
            }
    }
}

func downloadImage(from urlString: String,  complited: @escaping (UIImage?) -> Void){
    let cache = NSCache<NSString, UIImage>()
    let cacheKey = NSString(string: urlString)
    if let image = cache.object(forKey: cacheKey){
        complited(image)
    }
    
    guard let url = URL(string: urlString) else {
        complited(nil)
        return
    }
    let task = URLSession.shared.dataTask(with: url){ data, response, error in
        guard let data = data, let image = UIImage(data: data) else {
            complited(nil)
            return
        }
        cache.setObject(image, forKey: cacheKey)
        complited(image)
    }
    task.resume()
    
}
