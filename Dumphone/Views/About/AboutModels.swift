import Foundation

struct AboutPage: Codable {
  let navigationTitle: String
  let backgroundStyle: BackgroundStyle
  let aboutHeader: SectionHeader
  let sections: [SectionData]
  let supportSection: SupportSection?
}

struct BackgroundStyle: Codable {
  let mainBackground: String
  let listRowBackground: String
  let listRowBackgroundOpacity: Double
}

struct SectionHeader: Codable {
  let title: String
  let text: String
}

struct SectionData: Codable {
  let title: String
  let links: [LinkData]
}

enum ImageType: String, Codable {
  case system
  case asset
}

struct LinkData: Codable {
  let url: String
  let text: String
  let primaryImage: String
  let primaryImageType: ImageType
  let secondaryImage: String
  let secondaryImageType: ImageType
}

struct SupportSection: Codable {
  let title: String
  let link: SupportLink
}

struct SupportLink: Codable {
  let url: String
  let image: String
  let backgroundColor: String
  let imageHeight: Int
}

// Extension to load the JSON file
extension AboutPage {
  static func load() -> AboutPage? {
    guard let url = Bundle.main.url(forResource: "AboutPage", withExtension: "json") else {
      print("❌ Could not find AboutPage.json in Views/About directory")
      return nil
    }

    guard let data = try? Data(contentsOf: url) else {
      print("❌ Could not read data from \(url)")
      return nil
    }

    do {
      let decoder = JSONDecoder()
      let result = try decoder.decode(AboutPage.self, from: data)
      print("✅ Successfully loaded AboutPage.json")
      return result
    } catch {
      print("❌ Failed to decode AboutPage.json: \(error)")
      return nil
    }
  }
}
