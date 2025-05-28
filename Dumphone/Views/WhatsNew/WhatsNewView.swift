//
//  WhatsNew.swift
//  FocusTap
//
//  Created by Trevor Walker on 5/6/25.
//

import SwiftUI

struct WhatsNewView: View {
  @StateObject private var viewModel = WhatsNewViewModel()
  var appVersion: String {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    return version
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        VStack(alignment: .leading) {
          Text("What's New")
            .font(.title2)
            .bold()

          Text(appVersion)
            .font(.system(.footnote, design: .monospaced))
            .padding(.leading, 2)
        }

        ForEach(viewModel.items, id: \.title) { item in
          VStack(alignment: .leading, spacing: 2) {
            Text("- \(item.title)")
              .font(.system(.body, design: .monospaced))
              .bold()

            Text(item.description)
              .font(.system(.footnote, design: .monospaced))
              .foregroundColor(.secondary)
              .padding(.leading, 16)
          }
        }

        Spacer()
      }
      .padding()
      .padding(.top, 16)
    }
  }
}

#Preview {
  WhatsNewView()
}

