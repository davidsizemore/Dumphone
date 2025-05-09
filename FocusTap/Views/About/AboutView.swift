//
//  AboutView.swift
//  FocusTap
//
//  Created by Trevor Walker on 4/11/25.
//

import SwiftUI

struct AboutView: View {
  let pageData: AboutPage? = AboutPage.load()

  @State private var showWhatsNew: Bool = false

  var body: some View {
    if let data = pageData {
      List {
        // About Header
        aboutHeader(data.aboutHeader)
          .listRowBackground(Color.secondary.opacity(data.backgroundStyle.listRowBackgroundOpacity))

        Section("What's New") {
          Button {
            showWhatsNew = true
          } label: {
            HStack {
              ImageWithType(
                imageName: "sparkles",
                imageType: .system,
                size: CGSize(width: 30, height: 30)
              )
              Text("See What's New")

              Spacer()

              ImageWithType(
                imageName: "arrow.right",
                imageType: .system,
                size: CGSize(width: 13, height: 13)
              )
            }
            .padding(.vertical, 4)
          }
          .listRowBackground(Color.secondary.opacity(data.backgroundStyle.listRowBackgroundOpacity))
          .foregroundStyle(.primary)
          .popover(isPresented: $showWhatsNew) {
            WhatsNewView()
          }
        }

        ForEach(data.sections, id: \.title) { section in
          Section(section.title) {
            ForEach(section.links, id: \.url) { link in
              Link(destination: URL(string: link.url)!) {
                HStack {
                  ImageWithType(
                    imageName: link.primaryImage,
                    imageType: link.primaryImageType,
                    size: CGSize(width: 30, height: 30)
                  )
                  Text(link.text)
                    .padding(.leading, 10)

                  Spacer()

        // Support Section
        if let data = data.supportSection { supportSection(data) }
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

        Section {
          AppVersionText()
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

  private func aboutHeader(_ data: SectionHeader) -> some View {
    Section {
      Text(data.text)
        .padding(.vertical, 4)
    } header: {
      Text(data.title)
        .font(.headline)
    }
  }

  private func linkList(from data: [SectionData], backgroundColor: Color) -> some View {
    ForEach(data, id: \.title) { section in
      Section(section.title) {
        ForEach(section.links, id: \.url) { link in
          aboutLink(link)
            .listRowBackground(backgroundColor)
            .foregroundStyle(.primary)
        }
      }
    }
  }

  private func aboutLink(_ link: LinkData) -> some View {
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
  }

  private func supportSection(_ data: SupportSection) -> some View {
    Section(data.title) {
      Link(destination: URL(string: data.link.url)!) {
        Image(data.link.image)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: CGFloat(data.link.imageHeight))
      }
      .listRowBackground(Color(hex: data.link.backgroundColor))
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
