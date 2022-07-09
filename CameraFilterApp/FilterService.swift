//
//  FilterService.swift
//  CameraFilterApp
//
//  Created by anies1212 on 2022/07/09.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FilterService {
    private var context: CIContext
    
    init() {
        self.context = CIContext()
    }
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        return Observable.create { observer in
            self.applyFilter(to: inputImage) { image in
                observer.onNext(image)
            }
            return Disposables.create()
        }
    }
    
    private func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage)->())){
        let filter = CIFilter(name: "CICMYKHalftone")
        filter?.setValue(5.0, forKey: kCIInputWidthKey)
        guard let sourceImage = CIImage(image: inputImage) else {return}
        filter?.setValue(sourceImage, forKey: kCIInputImageKey)
        guard let outputImage = filter?.outputImage else {return}
        if let cgImage = self.context.createCGImage(outputImage, from: outputImage.extent){
            let processedImage = UIImage(cgImage: cgImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
            completion(processedImage)
        }
    }
}
