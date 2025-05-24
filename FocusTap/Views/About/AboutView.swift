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
      VStack(spacing: 0) {
        // Add padding at the top of the viewport
        Spacer().frame(height: 32)
        List {
          // About Header
          aboutHeader(data.aboutHeader)
            .listRowBackground(Color.black)

          ForEach(data.sections, id: \.title) { section in
            Section(header: Text(section.title)
              .font(.system(size: 20, design: .monospaced))
              .foregroundColor(.white)) {
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
                      .font(.system(.body, design: .monospaced))
                      .foregroundColor(.white)

                    Spacer()

          // Support Section
          if let data = data.supportSection { supportSection(data) }
                    ImageWithType(
                      imageName: link.secondaryImage,
                      imageType: link.secondaryImageType
                    )
                  }
                }
                .listRowBackground(Color.black)
                .foregroundStyle(.primary)
              }
            }
          }
        }
        .background(Color.black)
        .scrollContentBackground(.hidden)
        .navigationTitle(data.navigationTitle)
        Spacer(minLength: 0)
        AppVersionText()
          .padding(.bottom, 16)
      }
      .background(Color.black)
    } else {
      Text("Failed to load about page data")
        .foregroundColor(.red)
        .font(.system(.body, design: .monospaced))
    }
  }

  private func aboutHeader(_ data: SectionHeader) -> some View {
    Section {
      Text(data.text)
        .padding(.vertical, 4)
        .font(.system(.body, design: .monospaced))
        .foregroundColor(.white)
    } header: {
      Text(data.title)
        .font(.system(size: 20, design: .monospaced))
        .foregroundColor(.white)
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
          .font(.system(.body, design: .monospaced))
          .foregroundColor(.white)
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

#Preview {
    NavigationView {
        AboutView()
    }
    .preferredColorScheme(.dark)
}
