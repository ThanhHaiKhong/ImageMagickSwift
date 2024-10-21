import Foundation
import MagickCore
import MagickWand

public class ImageMagickWrapper {
    
    private var wand: MagickWand?
    
    init() {
        initializeMagick()
    }
    
    private func initializeMagick() {
        MagickWandGenesis()
        wand = NewMagickWand()
    }
    
    func loadImage(from path: String) -> MagickWand? {
        guard let wand = NewMagickWand() else {
            return nil
        }
        MagickReadImage(wand, path)
        return wand
    }
    
    func resizeImage(_ wand: MagickWand, with attributes: ImageAttributes) -> MagickWand? {
        MagickResizeImage(wand, attributes.width, attributes.height, LanczosFilter)
        return wand
    }

    func convertImage(_ wand: MagickWand, to attributes: OutputAttributes) -> Bool {
        MagickSetImageFormat(wand, attributes.format)
        MagickSetImageCompression(wand, JPEGCompression)
        MagickSetImageCompressionQuality(wand, attributes.quality)
        return true
    }
    
    func compressJPEGImage(_ wand: MagickWand, quality: Int) -> MagickWand? {
        MagickSetImageCompressionQuality(wand, quality)
        return wand
    }
    
    func compressImageWithAttributes(_ wand: MagickWand, attributes: CompressionAttributes) -> MagickWand? {
        MagickSetImageFormat(wand, attributes.format)
        
        if attributes.format.lowercased() == "jpeg" {
            return compressJPEGImage(wand, quality: attributes.quality)
        } else if attributes.format.lowercased() == "png" {
            return compressPNGImage(wand, compressionLevel: attributes.quality)
        }
        return wand
    }
    
    func compressPNGImage(_ wand: MagickWand, compressionLevel: Int) -> MagickWand? {
        if MagickSetImageCompressionQuality(wand, compressionLevel) == MagickFalse {
            return nil
        }
        
        if MagickSetImageFormat(wand, "PNG") == MagickFalse {
            return nil
        }
        
        return wand
    }
}

// Define Types

public extension ImageMagickWrapper {
    typealias MagickWand = OpaquePointer
    
    struct ImageAttributes {
        let width: Int
        let height: Int
        let format: String
        let quality: Int
    }

    struct OutputAttributes {
        let format: String
        let quality: Int
    }
    
    struct CompressionAttributes {
        let quality: Int  // Chất lượng nén
        let format: String  // Định dạng (JPEG, PNG, GIF,...)
    }
}
