//

import UIKit

class QRCodeGenerator {
    var isInverted: Bool = false
    var isTransparent: Bool = false
    var tintColor: UIColor?
    
    func generate(from string: String, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .default).async {
            let data = string.data(using: String.Encoding.utf8)
            
            if let filter = CIFilter(name: "CIQRCodeGenerator") {
                filter.setValue(data, forKey: "inputMessage")
                
                if var output = filter.outputImage {
                    let transform = CGAffineTransform(scaleX: size.width / output.extent.size.width,
                                                      y: size.width / output.extent.size.width)
                    output = output.transformed(by: transform)
                    
                    var finalOutput: CIImage? = output
                    if self.isInverted {
                        finalOutput = finalOutput?.inverted
                    }
                    if self.isTransparent {
                        finalOutput = finalOutput?.transparent
                    }
                    if let color = self.tintColor {
                        finalOutput = finalOutput?.tinted(using: color)
                    }
                    
                    DispatchQueue.main.async {
                        let image = UIImage(ciImage: finalOutput ?? output)
                        completion(image)
                    }
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func generate(string: String, in imageView: UIImageView, completion: ((UIImage) -> Void)? = nil) {
        generate(from: string, size: imageView.bounds.size, completion: { image in
            guard let image = image else { return }
            
            imageView.image = image
            completion?(image)
        })
    }
}

fileprivate extension CIImage {
    var transparent: CIImage? {
        return inverted?.blackToTransparent
    }
    
    var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }
        
        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }
    
    var blackToTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }
    
    func tinted(using color: UIColor) -> CIImage? {
        guard let transparentQRImage = transparent,
            let filter = CIFilter(name: "CIMultiplyCompositing"),
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }
        
        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage
        
        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)
        
        return filter.outputImage
    }
}
