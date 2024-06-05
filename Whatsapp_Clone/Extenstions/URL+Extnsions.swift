//
//  URL+Extnsions.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 28/05/24.
//

import Foundation
import UIKit
import AVFoundation

extension URL{
    
    static  var stubURL:URL{
        return URL(string: "https://google.com")!
    }
    
    func generateVideoThumbnail()async throws -> UIImage?{
        let asset = AVAsset(url: self)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 1, preferredTimescale: 60)
        
        return try await withCheckedThrowingContinuation { continuation in
            imageGenerator.generateCGImageAsynchronously(for: time) { cgImage, _, error in
                if let cgImage = cgImage{
                    let thumbnailImage = UIImage(cgImage: cgImage)
                    continuation.resume(returning: thumbnailImage)
                }else{
                    continuation.resume(throwing: error ?? NSError(domain: "", code: 0))
                }
            }
        }
    }
}
