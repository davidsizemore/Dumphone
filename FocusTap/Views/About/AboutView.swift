//
//  AboutView.swift
//  FocusTap
//
//  Created by Trevor Walker on 4/11/25.
//

import SwiftUI

struct AboutView: View {
  let sections: [AboutSection] = [
    AboutSection(title: "Project Links",
                 links: [
                  AboutLink(url: "https://github.com/Walker123t/FocusTap",
                            text: "View project on Github",
                            primaryImage: Image("github-logo"),
                            secondaryImage: Image(systemName: "arrow.up.right.square")),
                  AboutLink(url: "https://github.com/OzTamir/broke",
                            text: "View original project's Github",
                            primaryImage: Image("github-logo"),
                            secondaryImage: Image(systemName: "arrow.up.right.square"))
                 ]),
    AboutSection(title: "Tell Me What You Think",
                 links: [
                  AboutLink(url: "mailto:FocusTapSupport@proton.me?subject=FocusTap%20Bug%20Report",
                            text: "Report a Bug",
                            primaryImage: Image(systemName: "ant.circle"),
                            secondaryImage: Image(systemName: "envelope")),
                  AboutLink(url: "mailto:FocusTapSupport@proton.me?subject=FocusTap%20Feedback",
                            text: "Feedback",
                            primaryImage: Image(systemName: "text.bubble"),
                            secondaryImage: Image(systemName: "envelope"))
                 ])
  ]

  var body: some View {
    List {
      Section {
        Text("FocusTap helps you stay focused by using NFC tags block apps that distract you")
          .padding(.vertical, 4)
      } header: {
        Text("About Fous Tap")
          .font(.headline)
      }
      .listRowBackground(Color.secondary.opacity(0.2))

      ForEach(sections) { section in
        Section(section.title) {
          ForEach(section.links) { link in
            Link(destination: URL(string: link.url)!) {
              HStack {
                link.primaryImage
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 40, height: 40)
                Text(link.text)
                Spacer()
                link.secondaryImage
              }
            }
            .listRowBackground(Color.secondary.opacity(0.2))
            .foregroundStyle(.primary)
          }
        }
      }

      Section("Support future development!") {
        Link(destination: URL(string: "https://buymeacoffee.com/walker123t")!) {
          Image("buy-me-a-coffee")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 40)
        }
        .listRowBackground(Color(hex: "#FFDD00"))
      }
      .navigationTitle("About")
    }
    .background(Color("ProfileSectionBackground"))
    .scrollContentBackground(.hidden)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ForEach(ColorScheme.allCases, id: \.self) {
      AboutView().preferredColorScheme($0)
    }
  }
}
