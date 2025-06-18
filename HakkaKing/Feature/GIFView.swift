import SwiftUI
import UIKit
import ImageIO

struct GIFView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(imageView)

        // Constraint supaya UIImageView-nya ikut ukuran SwiftUI frame
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])

        if let path = Bundle.main.path(forResource: gifName, ofType: "gif"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let source = CGImageSourceCreateWithData(data as CFData, nil) {

            var images = [UIImage]()
            var totalDuration: Double = 0

            let count = CGImageSourceGetCount(source)
            for i in 0..<count {
                if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    let duration = GIFView.frameDuration(from: source, at: i)
                    totalDuration += duration
                    images.append(UIImage(cgImage: cgImage))
                }
            }

            let animatedImage = UIImage.animatedImage(with: images, duration: totalDuration)
            imageView.image = animatedImage
        }

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    private static func frameDuration(from source: CGImageSource, at index: Int) -> Double {
        var frameDuration = 0.1
        if let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
           let gifProperties = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any],
           let delayTime = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? Double ??
                           gifProperties[kCGImagePropertyGIFDelayTime] as? Double {
            frameDuration = delayTime
        }
        return frameDuration
    }
}
