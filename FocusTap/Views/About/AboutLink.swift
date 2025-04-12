//
//  AboutLink.swift
//  FocusTap
//
//  Created by Trevor Walker on 4/11/25.
//

import SwiftUI

struct AboutSection: Identifiable {
  let id = UUID()

  let title: String
  let links: [AboutLink]
}

struct AboutLink: Identifiable {
  var id = UUID()

  let url: String
  let text: String
  let primaryImage: Image
  let secondaryImage: Image
}
