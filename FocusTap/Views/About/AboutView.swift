//
//  AboutView.swift
//  FocusTap
//
//  Created by Trevor Walker on 4/11/25.
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
      case .asset:
        Image(imageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: size.width, height: size.height)
      }
    } else {
      switch imageType {
      case .system:
        Image(systemName: imageName)
      case .asset:
        Image(imageName)
      }
    }
  }
}

struct AboutView: View {
  let pageData: AboutPage? = AboutPage.load()

  var appVersion: String {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    return "Focus Tap - \(version)"
  }

  var body: some View {
    if let data = pageData {
      List {
        Section {
          Text(data.aboutSection.text)
            .padding(.vertical, 4)
        } header: {
          Text(data.aboutSection.title)
            .font(.headline)
        }
        .listRowBackground(Color.secondary.opacity(data.backgroundStyle.listRowBackgroundOpacity))

        ForEach(data.sections, id: \.title) { section in
          Section(section.title) {
            ForEach(section.links, id: \.url) { link in
              Link(destination: URL(string: link.url)!) {
                HStack {
                  ImageWithType(
                    imageName: link.primaryImage,
                    imageType: link.primaryImageType,
                    size: CGSize(width: 40, height: 40)
                  )

                  Text(link.text)
                  Spacer()

                  ImageWithType(
                    imageName: link.secondaryImage,
                    imageType: link.secondaryImageType
                  )
                }
              }
              .listRowBackground(Color.secondary.opacity(data.backgroundStyle.listRowBackgroundOpacity))
              .foregroundStyle(.primary)
            }
          }
        }

        Section(data.supportSection.title) {
          Link(destination: URL(string: data.supportSection.link.url)!) {
            Image(data.supportSection.link.image)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: CGFloat(data.supportSection.link.imageHeight))
          }
          .listRowBackground(Color(hex: data.supportSection.link.backgroundColor))
        }

        Section {
          Text(appVersion)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .listRowBackground(Color(data.backgroundStyle.mainBackground))
      }
      .background(Color(data.backgroundStyle.mainBackground))
      .scrollContentBackground(.hidden)
      .navigationTitle(data.navigationTitle)
    } else {
      Text("Failed to load about page data")
        .foregroundColor(.red)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ForEach(ColorScheme.allCases, id: \.self) {
      AboutView().preferredColorScheme($0)
    }
  }
}
