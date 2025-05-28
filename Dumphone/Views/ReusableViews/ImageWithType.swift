//
//  ImageWithType.swift
//  FocusTap
//
//  Created by Trevor Walker on 5/6/25. Edited by David Sizemore on 5/24/25.
//

import SwiftUI

struct ImageWithType: View {
  let imageName: String
  let imageType: ImageType
  let size: CGSize?

  init(imageName: String, imageType: ImageType, size: CGSize? = nil) {
    self.imageName = imageName
    self.imageType = imageType
    self.size = size
  }

  var body: some View {
    if let size = size {
      switch imageType {
      case .system:
        Image(systemName: imageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: size.width, height: size.height)
          .foregroundColor(.white)
      case .asset:
        Image(imageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: size.width, height: size.height)
          .foregroundColor(.white)
      }
    } else {
      switch imageType {
      case .system:
        Image(systemName: imageName)
          .foregroundColor(.white)
      case .asset:
        Image(imageName)
          .foregroundColor(.white)
      }
    }
  }
}
