import AppIntents
import SwiftUI

// MARK: - Shortcut Provider
struct ProfileShortcutsProvider: AppShortcutsProvider {
  static var shortcutTileColor: ShortcutTileColor = .blue

  static var appShortcuts: [AppShortcut] {
    let setProfileState = AppShortcut(
      intent: SetProfileStateIntent(),
      phrases: ["Enable Profile \(.applicationName)"],
      shortTitle: "Enable Profile",
      systemImageName: "clock.arrow.circlepath"
    )

    return [setProfileState]
  }
}

// MARK: - Set Profile State Intent
struct SetProfileStateIntent: AppIntent {
  static var title: LocalizedStringResource = "Enable Profile"

  @Parameter(title: "Profile")
  var profile: Profile

  init() {}

  init(profile: Profile) {
    self.profile = profile
  }

  static var parameterSummary: some ParameterSummary {
    Summary("\(\.$profile)")
  }

  func perform() async throws -> some IntentResult {
    ProfileManager.shared.setCurrentProfile(id: profile.id)
    AppBlocker.shared.enableBlocking(for: profile)

    return .result()
  }
}

struct ProfileQuery: EntityQuery {
    func entities(for identifiers: [Profile.ID]) async throws -> [Profile] {
        return identifiers.compactMap { id in
            ProfileManager.shared.profiles.first { $0.id == id }
        }
    }
    
    func suggestedEntities() async throws -> [Profile] {
        return ProfileManager.shared.profiles
    }
}

extension Profile: AppEntity {
  static var typeDisplayRepresentation: TypeDisplayRepresentation = "Profile"

  var displayRepresentation: DisplayRepresentation {
    DisplayRepresentation(title: "\(name)")
  }

  static var defaultQuery = ProfileQuery()
}

extension Profile {
    static var shortcutsProvider: ProfileShortcutsProvider {
        ProfileShortcutsProvider()
    }
}
