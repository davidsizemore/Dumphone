//
//  AboutView.swift
//  FocusTap
//
//  Created by Trevor Walker on 4/11/25.
//

import SwiftUI

struct AboutView: View {
  let links: [AboutLink] = [
    AboutLink(url: "https://github.com/Walker123t/FocusTap",
              text: "View project on Github",
              image: Image("github-logo")),
    AboutLink(url: "https://github.com/OzTamir/broke",
              text: "View original project's Github",
              image: Image("github-logo"))
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

      Section("Project Links") {
        ForEach(links) { link in
          Link(destination: URL(string: link.url)!) {
            HStack {
              link.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
              Text(link.text)
              Spacer()
              Image(systemName: "arrow.up.right.square")
            }
          }
          .listRowBackground(Color.secondary.opacity(0.2))
          .foregroundStyle(.primary)
        }
      }

      Section("Report a Bug") {
        Link(destination: URL(string: "mailto:FocusTapSupport@proton.me?subject=FocusTap%20Bug%20Report")!) {
          HStack {
            Image(systemName: "ant.circle")
            Text("Report a Bug")
            Spacer()
            Image(systemName: "envelope")
          }
          .frame(height: 40)
        }
        .listRowBackground(Color.secondary.opacity(0.2))
        .foregroundStyle(.primary)
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
