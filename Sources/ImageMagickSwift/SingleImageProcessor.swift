//
//  SingleImageProcessor.swift
//  ImageMagickSwift
//
//  Created by Thanh Hai Khong on 22/10/24.
//

import UIKit
import MagickCore
import MagickWand

public struct SingleImageProcessor {
    private var wand: MagickWand
    
    public init?(imagePath: String) async {
        guard let wand = NewMagickWand() else { return nil }
        if MagickReadImage(wand, imagePath) == MagickFalse {
            DestroyMagickWand(wand)
            return nil
        }
        self.wand = wand
    }
}

extension SingleImageProcessor {
    public func resize(width: Int, height: Int) async -> SingleImageProcessor {
        MagickResizeImage(wand, width, height, LanczosFilter)
        return self
    }
}

extension SingleImageProcessor {
    public func rotate(degrees: Double) async -> SingleImageProcessor {
        MagickRotateImage(wand, NewPixelWand(), degrees)
        return self
    }
}

extension SingleImageProcessor {
    public func crop(x: Int, y: Int, width: Int, height: Int) async -> SingleImageProcessor {
        MagickCropImage(wand, width, height, x, y)
        return self
    }
}

extension SingleImageProcessor {
    public func flipHorizontally() async -> SingleImageProcessor {
        MagickFlopImage(wand)
        return self
    }
}

extension SingleImageProcessor {
    public func flipVertically() async -> SingleImageProcessor {
        MagickFlipImage(wand)
        return self
    }
}

extension SingleImageProcessor {
    public func flipBoth() async -> SingleImageProcessor {
        MagickFlopImage(wand)
        MagickFlipImage(wand)
        return self
    }
}

extension SingleImageProcessor {
    public func save(to path: String) async -> Bool {
        return MagickWriteImage(wand, path) == MagickTrue
    }
}

extension SingleImageProcessor {
    public func getImage() async -> UIImage? {
        return await getUIImage(from: wand)
    }
    
    public func getImageData() async -> Data? {
        return await getImageData(from: wand)
    }
    
    private func getUIImage(from wand: MagickWand) async -> UIImage? {
        var length: Int = 0
        guard let blob = MagickGetImageBlob(wand, &length) else {
            return nil
        }
        let imageData = Data(bytes: blob, count: length)
        MagickRelinquishMemory(blob)
        return UIImage(data: imageData)
    }
    
    private func getImageData(from wand: MagickWand) async -> Data? {
        var length: Int = 0
        guard let blob = MagickGetImageBlob(wand, &length) else {
            return nil
        }
        let imageData = Data(bytes: blob, count: length)
        MagickRelinquishMemory(blob)
        return imageData
    }
}

extension SingleImageProcessor {
    public func blur(radius: Double, sigma: Double) async -> SingleImageProcessor {
        MagickAdaptiveBlurImage(wand, radius, sigma)
        return self
    }
}
