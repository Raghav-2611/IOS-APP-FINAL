//
//  OnboardingViewController.swift
//  HomePageSaanjha
//
//  Created by user@99 on 27/11/25.
//
import UIKit

class OnboardingViewController: UIPageViewController {
    
    private var pages = [UIViewController]()
    private var pageControl = UIPageControl()
    private var skipButton = UIButton(type: .system)
    private var initialPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        layout()
    }
    
    private func setup() {
        dataSource = self
        delegate = self
        
        // Create onboarding pages
        let page1 = createOnboardingPage(
            backgroundImageName: "onboarding_background_1",
            title: "Welcome to Saanjha",
            subtitle: "Track your pregnancy journey with expert guidance and support"
        )
        
        let page2 = createOnboardingPage(
            backgroundImageName: "onboarding_background_2",
            title: "Track Your Baby's Growth",
            subtitle: "Monitor weekly updates, size comparisons, and developmental milestones"
        )
        
        let page3 = createOnboardingPage(
            backgroundImageName: "onboarding_background_3",
            title: "Connect With Your Partner",
            subtitle: "Share milestones, track appointments, and experience pregnancy together"
        )
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 1.0, green: 0.69, blue: 0.73, alpha: 1.0)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        skipButton.setTitle("Skip", for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
    }
    
    private func style() {
        view.backgroundColor = UIColor(red: 1.0, green: 0.95, blue: 0.96, alpha: 1.0)
    }
    
    private func layout() {
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func createOnboardingPage(backgroundImageName: String, title: String, subtitle: String) -> OnboardingPageViewController {
        let vc = OnboardingPageViewController()
        vc.backgroundImageName = backgroundImageName
        vc.titleText = title
        vc.subtitleText = subtitle
        return vc
    }
    
    @objc private func skipTapped() {
        completeOnboarding()
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")

        let welcome = WelcomeSaanjhaViewController()
        let nav = UINavigationController(rootViewController: welcome)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        present(nav, animated: true)
    }

}

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return nil
        }
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
        
        // Auto-proceed after last page
        if currentIndex == pages.count - 1 {
            skipButton.setTitle("Get Started", for: .normal)
        } else {
            skipButton.setTitle("Skip", for: .normal)
        }
    }
}

