//
//  BrockerView.swift
//  Broke
//
//  Created by Oz Tamir on 23/08/2024. Updated UI by David Sizemore 23/05/2025.
//

import SwiftUI
import CoreNFC
import SFSymbolsPicker
import FamilyControls
import ManagedSettings

struct HomeView: View {
  // MARK: - Environment
  @EnvironmentObject private var appBlocker: AppBlocker
  @EnvironmentObject private var profileManager: ProfileManager

  // MARK: - State
  @StateObject private var nfcReader = NFCReader()
  @State private var alertType: AlertType?
  @State private var showAboutPage: Bool = false
  @State private var showWhatsNewPage: Bool = false


  // MARK: - Alert Type
  private enum AlertType: Identifiable {
    case wrongTag
    case notFocusTag
    case createTag

    var id: Int {
      switch self {
      case .wrongTag: return 0
      case .notFocusTag: return 1
      case .createTag: return 2
      }
    }
  }

  // MARK: - Computed Properties
  private var isBlocking: Bool { appBlocker.isBlocking }

  // MARK: - View Body
  var body: some View {
    NavigationView {
      GeometryReader { geometry in
        mainContent(geometry: geometry)
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          aboutButton
        }

        if !isBlocking {
          ToolbarItem(placement: .topBarTrailing) {
            createTagButton
          }
        }
      }
      .alert(item: $alertType, content: alertContent)
    }
    .animation(.spring(), value: isBlocking)
    .onOpenURL { url in
      switch isBlocking {
      case true:
        handleUnblockingTag(payload: url.absoluteString, currentProfile: profileManager.currentProfile)
      case false:
        handleBlockingTag(payload: url.absoluteString, currentProfile: profileManager.currentProfile)
      }
    }
    .sheet(isPresented: $showAboutPage) { AboutView() }
    .sheet(isPresented: $showWhatsNewPage) { WhatsNewView() }
  }

  // MARK: - Main Layout Views
  private func mainContent(geometry: GeometryProxy) -> some View {
    ZStack {
      VStack(spacing: 0) {
        Spacer()
        blockOrUnblockButton(geometry: geometry)
        Spacer()
        profilesList(geometry: geometry)
          .padding(.bottom, 32)
      }
      .background(backgroundColor)
      .frame(maxHeight: .infinity, alignment: .bottom)
    }
  }

  private func profilesList(geometry: GeometryProxy) -> some View {
    ProfilesPickerView(profileManager: profileManager)
      .animation(.easeOut(duration: 1), value: isBlocking)
  }

  // MARK: - UI Components
  private func blockOrUnblockButton(geometry: GeometryProxy) -> some View {
    VStack(spacing: 8) {
      Button(action: {
        withAnimation(.spring()) {
          scanTag()
        }
      }) {
        Image(isBlocking ? "RedIcon" : "GreenIcon")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 240, height: 240)
      }
      .transition(.scale)
    }
    .animation(.spring(), value: isBlocking)
  }

  private var aboutButton: some View {
    Button(action: {
      showAboutPage.toggle()
    }) {
      Image(systemName: "questionmark")
    }
  }

  private var createTagButton: some View {
    Button(action: {
      alertType = .createTag
    }) {
      Image(systemName: "radiowaves.right")
    }
    .disabled(!NFCNDEFReaderSession.readingAvailable)
  }

  private var backgroundColor: Color {
    isBlocking ? Color("BlockingBackground") : Color("NonBlockingBackground")
  }

  // MARK: - Alert Handling
  private func alertContent(for type: AlertType) -> Alert {
    switch type {
    case .wrongTag:
      return Alert(
        title: Text(.wrongTag(.title))
          .font(.system(.headline, design: .monospaced)),
        message: Text(.wrongTag(.message))
          .font(.system(.body, design: .monospaced)),
        dismissButton: .default(Text(.ok)
          .font(.system(.body, design: .monospaced)))
      )
    case .notFocusTag:
      return Alert(
        title: Text(.notFocusTag(.title))
          .font(.system(.headline, design: .monospaced)),
        message: Text(.notFocusTag(.message))
          .font(.system(.body, design: .monospaced)),
        dismissButton: .default(Text(.ok)
          .font(.system(.body, design: .monospaced)))
      )
    case .createTag:
      return Alert(
        title: Text(.createTag(.title))
          .font(.system(.headline, design: .monospaced)),
        message: Text(.createTag(.message))
          .font(.system(.body, design: .monospaced)),
        primaryButton: .default(Text(.create)
          .font(.system(.body, design: .monospaced))) { createFocusTag() },
        secondaryButton: .cancel(Text(.cancel)
          .font(.system(.body, design: .monospaced)))
      )
    }
  }

  // MARK: - NFC Tag Handling
  private func scanTag() {
    if !isBlocking &&
       !profileManager.currentProfile.requireTagToBlock {
      handleBlockingTag(payload: "", currentProfile: profileManager.currentProfile)
      return
    }

    nfcReader.scan { payload in
      let currentProfile = profileManager.currentProfile

      if isBlocking {
        handleUnblockingTag(payload: payload, currentProfile: currentProfile)
      } else {
        handleBlockingTag(payload: payload, currentProfile: currentProfile)
      }
    }
  }

  private func handleUnblockingTag(payload: String, currentProfile: Profile) {
    if currentProfile.requireMatchingTag {
      if payload == currentProfile.tagPhrase {
        NSLog(.logs(.matchingTag))
        appBlocker.toggleBlocking(for: currentProfile)
      } else if String(payload.prefix(11)) == "focusTap://" {
        alertType = .wrongTag
        NSLog(.logs(.wrongTag), payload)
      } else {
        alertType = .notFocusTag
        NSLog(.logs(.nonBrokeTag), payload)
      }
    } else {
      NSLog(.logs(.noMatchRequired))
      appBlocker.toggleBlocking(for: currentProfile)
    }
  }

  private func handleBlockingTag(payload: String, currentProfile: Profile) {
    if let matchingProfile = profileManager.profiles.first(where: { $0.tagPhrase == payload }) {
      profileManager.setCurrentProfile(id: matchingProfile.id)
      NSLog(.logs(.switchingProfile), matchingProfile.name)
      appBlocker.toggleBlocking(for: matchingProfile)
    } else if !currentProfile.requireTagToBlock {
      appBlocker.toggleBlocking(for: currentProfile)
    } else {
      alertType = .notFocusTag
    }
  }

  private func createFocusTag() {
    nfcReader.write(profileManager.currentProfile.tagPhrase)
  }
}

#Preview {
    HomeView()
        .environmentObject(AppBlocker.shared)
        .environmentObject(ProfileManager.shared)
        .preferredColorScheme(.dark)
}
