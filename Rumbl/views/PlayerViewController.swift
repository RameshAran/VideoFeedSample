//
//  PlayerViewController.swift
//  Rumbl
//
//  Created by Ramesh A on 29/02/20.
//  Copyright © 2020 Ramesh A. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    var nodes:[Node]?
    var currentIndex: Int = 0
    var videoControllers: [VideoPlayerViewController] = [VideoPlayerViewController]()
    var pageViewController: PlayerPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func onSwipeRight(_ sender: Any) {
        popView()
    }
    
    @IBAction func showPreviewVC(_ sender: Any) {
        popView()
    }
    
    func loadVideos() {
        guard let videoNodes = nodes else {
            return
        }
        
        for node in videoNodes {
            let playerVC = VideoPlayerViewController(node.video)
            videoControllers.append(playerVC)
        }
        if !videoControllers.isEmpty {
            let selectedVideoVC = videoControllers[currentIndex]
            pageViewController?.setViewControllers([selectedVideoVC], direction: .forward, animated: true) { (status) in
                print(status)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? PlayerPageViewController {
            pageViewController = destinationVC
            pageViewController?.delegate = self
            pageViewController?.dataSource = self
            loadVideos()
        }
    }
    
    func popView() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PlayerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let videoVC = viewController as? VideoPlayerViewController else {
            return nil
        }
        guard let viewControllerIndex = videoControllers.firstIndex(of: videoVC) else {
            return nil
        }
        if viewControllerIndex == 0 {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard videoControllers.count > previousIndex else {
            return nil
        }
        return videoControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let videoVC = viewController as? VideoPlayerViewController else {
            return nil
        }
        guard let viewControllerIndex = videoControllers.firstIndex(of: videoVC) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        if viewControllerIndex == videoControllers.count - 1 {
            return nil
        }
        guard videoControllers.count > nextIndex else {
            return nil
        }
        return videoControllers[nextIndex]
    }
}

extension PlayerViewController: UIPageViewControllerDelegate {
    
}
