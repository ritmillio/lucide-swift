import Foundation

#if canImport(UIKit)
import UIKit
typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
typealias PlatformImage = NSImage
#endif

struct LucideIcon {
    private var name: String

    init(name: String) {
        self.name = name
    }

    var image: PlatformImage? {
        #if canImport(UIKit)
        return UIImage(named: name, in: .module, with: nil)
        #elseif canImport(AppKit)
        guard let bundleURL = Bundle.module.url(forResource: name, withExtension: "pdf") else { return nil }
        return NSImage(contentsOf: bundleURL)
        #endif
    }
}

class LucideIcons {
    static func icon(named name: String) -> LucideIcon {
        return LucideIcon(name: name)
    }

    // Optionally, if you want to list all icons
    static var allIcons: [LucideIcon] {
        // Assuming you have a method to list all PDF filenames in the bundle
        let iconNames = listAllPDFIconNames()
        return iconNames.map { LucideIcon(name: $0) }
    }

   private static func listAllPDFIconNames() -> [String] {
    guard let resourcePath = Bundle.module.resourcePath else { return [] }
    let iconsDirectoryPath = resourcePath.appending("/resources/lucide-icons")
    do {
        let iconFiles = try FileManager.default.contentsOfDirectory(atPath: iconsDirectoryPath)
        let pdfIconNames = iconFiles.filter { $0.hasSuffix(".pdf") }.map { $0.replacingOccurrences(of: ".pdf", with: "") }
        return pdfIconNames
    } catch {
        print("Error listing icons: \(error)")
        return []
    }
}

}
