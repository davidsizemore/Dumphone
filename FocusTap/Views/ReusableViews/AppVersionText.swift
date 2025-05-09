//
//  AppVersionText.swift
//  FocusTap
//
//  Created by Trevor Walker on 5/6/25.
//

import SwiftUI

struct AppVersionText: View {
  private var appVersion: String {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    return "Focus Tap - \(version)"
  }

  var body: some View {
    Text(appVersion)
      .foregroundStyle(.secondary)
      .frame(maxWidth: .infinity, alignment: .center)
  }
}

#Preview {
  AppVersionText()
}
