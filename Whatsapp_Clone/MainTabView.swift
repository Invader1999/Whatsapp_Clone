//
//  MainTabView.swift
//  Whatsapp_Clone
//
//  Created by Kareddy Hemanth Reddy on 22/04/24.
//

import SwiftUI

struct MainTabView: View {
    private var currentUser: UserItem
    init(currentUser:UserItem) {
        self.currentUser = currentUser
        makeTabBarOpaque()
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    }

    
    var body: some View {
        TabView {
            UpdatesTabScreen()
                .tabItem {
                    Image(systemName: Tab.updates.icon)
                    Text(Tab.updates.title)
                }
            CallTabScreen()
                .tabItem {
                    Image(systemName: Tab.call.icon)
                    Text(Tab.call.title)
                }

            CommunityTabScreen()
                .tabItem {
                    Image(systemName: Tab.communities.icon)
                    Text(Tab.communities.title)
                }
            ChannelTabScreen()
                .tabItem {
                    Image(systemName: Tab.chats.icon)
                    Text(Tab.chats.title)
                }
            SettingTabScreen()
                .tabItem {
                    Image(systemName: Tab.settings.icon)
                    Text(Tab.settings.title)
                }
        }
        // .tint(.green)
    }

    private func makeTabBarOpaque() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

extension MainTabView {
    private func placeholdeItemView(_ title: String) -> some View {
        Text(title)
            .font(.largeTitle)
    }

    private enum Tab: String {
        case updates, call, communities, chats, settings

        fileprivate var title: String {
            return rawValue.capitalized
        }

        fileprivate var icon: String {
            switch self {
            case .updates:
                return "circle.dashed.inset.filled"
            case .call:
                return "phone"
            case .communities:
                return "person.3"
            case .chats:
                return "message"
            case .settings:
                return "gear"
            }
        }
    }
}

#Preview {
    MainTabView(currentUser: .placeholder)
}
