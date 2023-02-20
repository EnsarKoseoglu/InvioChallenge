//
//  Images.swift
//  InvioChallenge
//
//  Created by EnsarKoseoglu on 19.02.2023.
//

import UIKit

internal enum Asset {
  internal static let like = ImageAsset(name: "like-fill")
  internal static let unlike = ImageAsset(name: "like-empty")
  internal static let placeholder = ImageAsset(name: "placeholder-poster")
  internal static let back = ImageAsset(name: "left-arrow")
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: UIImage {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS)
    let image = UIImage(named: name, in: bundle, compatibleWith: nil)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

private final class BundleToken {}
