//
//  BatchImageProcessor.swift
//  ImageMagickSwift
//
//  Created by Thanh Hai Khong on 22/10/24.
//

import Foundation
import MagickCore
import MagickWand

public struct BatchImageProcessor {
    private var images: [MagickWand]
    
    init?(imagePaths: [String]) {
        self.images = []
        for path in imagePaths {
            guard let wand = NewMagickWand() else { return nil }
            if MagickReadImage(wand, path) == MagickFalse {
                _ = DestroyMagickWand(wand)
                return nil
            }
            images.append(wand)
        }
    }
    
    mutating func resize(width: Int, height: Int) -> BatchImageProcessor {
        images = images.map { wand in
            MagickResizeImage(wand, width, height, LanczosFilter)
            return wand
        }
        return self
    }
    
    mutating func rotate(degrees: Double) -> BatchImageProcessor {
        images = images.map { wand in
            MagickRotateImage(wand, NewPixelWand(), degrees)
            return wand
        }
        return self
    }
    
    func saveAll(to directory: String) -> Bool {
        for (index, wand) in images.enumerated() {
            let path = "\(directory)/image\(index).jpg"
            if MagickWriteImage(wand, path) != MagickTrue {
                return false
            }
        }
        return true
    }
    
    func getImages() -> [MagickWand] {
        return images
    }
}
