//
//  SceneDelegate.swift
//

import UIKit
import SwiftData
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var modelContainer: ModelContainer!   // Shared SwiftData container

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // MARK: 1 — Create ONE global SwiftData container
        do {
            self.modelContainer = try ModelContainer(for: VaultReport.self)
        } catch {
            fatalError("❌ Failed creating ModelContainer: \(error)")
        }

        let window = UIWindow(windowScene: windowScene)

        // MARK: 2 — App state checks
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        let isLoggedIn = Auth.auth().currentUser != nil

        // MARK: 3 — Navigation decision
        if !hasCompletedOnboarding {
            // First launch → onboarding
            let onboardingVC = OnboardingViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal
            )
            window.rootViewController = onboardingVC

        } else if !isLoggedIn {
            // Onboarding done but user not logged in
            window.rootViewController = LoginViewController()

        } else {
            let loginVC = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            window.rootViewController = nav

        }

        window.makeKeyAndVisible()
        self.window = window
    }

    // MARK: - Main Tab Bar
    func makeMainTabBar() -> UITabBarController {

        let homeVC     = HomeViewController()
        let scheduleVC = ScheduleViewController()
        let trackingVC = TrackingViewController()
        let insightsVC = InsightsViewController()

        let homeNav     = UINavigationController(rootViewController: homeVC)
        let scheduleNav = UINavigationController(rootViewController: scheduleVC)
        let trackNav    = UINavigationController(rootViewController: trackingVC)
        let insightsNav = UINavigationController(rootViewController: insightsVC)

        homeNav.tabBarItem     = UITabBarItem(title: "Home",     image: UIImage(systemName: "house.fill"),     tag: 0)
        scheduleNav.tabBarItem = UITabBarItem(title: "Schedule", image: UIImage(systemName: "calendar"),       tag: 1)
        trackNav.tabBarItem    = UITabBarItem(title: "Tracking", image: UIImage(systemName: "chart.bar.fill"), tag: 2)
        insightsNav.tabBarItem = UITabBarItem(title: "Insights", image: UIImage(systemName: "lightbulb.fill"), tag: 3)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            homeNav,
            scheduleNav,
            trackNav,
            insightsNav
        ]

        tabBarController.tabBar.tintColor = .saanjhaSoftPink
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = .white

        return tabBarController
    }
}
