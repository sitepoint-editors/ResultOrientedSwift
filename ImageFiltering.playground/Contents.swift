import Foundation
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//: Define `Result<T>` enum
enum Result<T> {
    case success(T)
    case error(Error)
}

//: Define `PhotoError`
enum PhotoError: Error {
    // Invalid url string used
    case invalidURL(String)
    // Invalid data used
    case invalidData
}

//: Define method for filtering the image
func applyFilterToImage(at urlString: String, completion: @escaping ((Result<UIImage>) -> ())) {
    
    // Check if `URL` object can be created from the URL string
    guard let url = URL(string: urlString) else {
        completion(.error(PhotoError.invalidURL(urlString)))
        return
    }
    
    // Create background queue
    let backgroundQueue = DispatchQueue.global(qos: .background)
    
    // Dispatch to background queue
    backgroundQueue.async {
        do {
            let data = try Data(contentsOf: url)
            
            // Check if `UIImage` object can be constructed with data
            guard let image = UIImage(data: data) else {
                completion(.error(PhotoError.invalidData))
                return
            }
            
            // Dispatch filtering to main queue
            DispatchQueue.main.async {
                // Crate sepia filter
                let filter = CIFilter(name: "CISepiaTone")!
                
                // Setup filter options
                let inputImage = CIImage(image: image)
                filter.setDefaults()
                filter.setValue(inputImage, forKey: kCIInputImageKey) // Set input image
                
                // Get filtered image
                let filteredImage = UIImage(ciImage: filter.outputImage!)
                
                // Return succesful result
                completion(.success(filteredImage))
            }
        } catch {
            // Dispatch error completion to main queue
            DispatchQueue.main.async { completion(.error(error)) }
        }
    }
}

//: Usage

let imageURL = Bundle.main.path(forResource: "landscape", ofType: "png")!

// Open the Assistant Editor to see results:
applyFilterToImage(at: "file://" + imageURL) { result in
    switch result {
    case let .success(filteredImage):
        // Sucess
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        imageView.backgroundColor = .red
        imageView.image = filteredImage
        PlaygroundPage.current.liveView = imageView
    case let .error(error):
        print(error)
    }
}
