//
//  WhatsNewViewModel.swift
//  FocusTap
//
//  Created by Trevor Walker on 5/6/25.
//

import Foundation

class WhatsNewViewModel: ObservableObject {
  @Published var items: [WhatsNewItem] = []

  init() {
    loadItems()
  }

  private func loadItems() {
    guard let url = Bundle.main.url(forResource: "WhatsNew", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let decoded = try? JSONDecoder().decode([WhatsNewItem].self, from: data) else {
      print("Failed to load or decode JSON")
      return
    }

    items = decoded
  }
}
