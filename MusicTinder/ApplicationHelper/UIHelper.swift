//
//  UIHelper.swift
//  MusicTinder
//
//  Created by Mate Lorincz on 05/11/16.
//  Copyright © 2016 MateLorincz. All rights reserved.
//

import UIKit

extension UIViewController {

    static func setBackButton(_ title: String, target: UIViewController) {
        var image = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 11, left: image!.size.width - 1, bottom: 0, right: 0))

        if #available(iOS 9.0, *) {
            let appearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationController.self])
            appearance.setBackButtonBackgroundImage(image, for: .normal, barMetrics: UIBarMetrics.default)
        } else {
            let appearance = UIBarButtonItem.appearance()
            appearance.setBackButtonBackgroundImage(image, for: .normal, barMetrics: UIBarMetrics.default)
        }

        target.navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        target.navigationController?.navigationBar.tintColor = UIColor.white
    }
}

extension UIColor {

    private static func colorWith(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }

    static func mtGreenColor() -> UIColor {
        return UIColor(netHex: 0x3CDB9F)
    }

    static func mtRedColor() -> UIColor {
        return UIColor(netHex: 0xF57B7B)
    }

    static func mtPurpleColor() -> UIColor {
        return UIColor(netHex: 0xA744DA)
    }

    static func mtWhiteColor() -> UIColor {
        return UIColor(netHex: 0xFCFCFC)
    }

    static func mtBlackColor() -> UIColor {
        return UIColor(netHex: 0x242424)
    }

    static func mtGrayColor() -> UIColor {
        return UIColor(netHex: 0x9F9F9F)
    }

    convenience init(netHex: Int) {
        self.init(red: CGFloat((netHex >> 16) & 0xff) / 255.0, green: CGFloat((netHex >> 8) & 0xff) / 255.0, blue: CGFloat(netHex & 0xff) / 255.0, alpha: 1.0)
    }
}

extension UIFont {

    static func applicationFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "FredokaOne-Regular", size: size)!
    }
}

class MyImageCache {

    static let sharedCache: NSCache = { () -> NSCache<AnyObject, AnyObject> in
        let cache = NSCache<AnyObject, AnyObject>()
        cache.name = "MyImageCache"
        cache.countLimit = 20 // Max 20 images in memory.
        cache.totalCostLimit = 10*1024*1024 // Max 10MB used.
        return cache
    }()

}

extension UINavigationItem {

    func applyNavigationItem(withImageName name: String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: name)
        imageView.image = image
        self.titleView = imageView
    }
}

extension URL {

    typealias ImageCacheCompletion = (UIImage) -> Void

    var cachedImage: UIImage? {
        return MyImageCache.sharedCache.object(forKey: absoluteString as AnyObject) as? UIImage
    }

    func fetchImage(_ completion: @escaping ImageCacheCompletion) {
        print("[DOWNLOAD] - image data from URL: \(self)")
        let task = URLSession.shared.dataTask(with: self, completionHandler: { data, _, error in

            if let  data = data, let image = UIImage(data: data), error == nil {
                MyImageCache.sharedCache.setObject(image, forKey: self.absoluteString as AnyObject, cost: data.count)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        })

        task.resume()
    }
}
