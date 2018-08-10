//
//  PageVC.swift
//  retilla
//
//  Created by satkis on 8/10/18.
//  Copyright © 2018 satkis. All rights reserved.
//


//https://www.youtube.com/watch?v=oX9o-DnMHsE

import UIKit



class PageVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var imageView: UIImageView?
    
    lazy var VCArr: [UIViewController] = {
        return [
            self.VCInstance(name: INITIALVC_1),
            self.VCInstance(name: INITIALVC_2),
            self.VCInstance(name: INITIALVC_3),
            self.VCInstance(name: INITIALVC_4)
        ]
    }()
    
    private func VCInstance(name: String) -> UIViewController {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        if let firstVC = VCArr.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
//        let bgView = UIView(frame: UIScreen.main.bounds)
////        bgView.backgroundColor = UIColor.orange
//        self.view.backgroundColor =
//        view.insertSubview(bgView, at: 0)
        
        imageView = UIImageView(image: UIImage(named: "bg.png")!)
        imageView!.contentMode = .scaleAspectFit
        
        view.insertSubview(imageView!, at: 0)
        
    }
    
    override func viewDidLayoutSubviews() {
        //this sets up dots at hte page bottom to clear background color. default if black
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
         //returting nil so on first PageVC it doesnt go in loop back to the last page.
        guard previousIndex >= 0 else {
            return nil
//            return VCArr.last
        }
        
        guard VCArr.count > previousIndex else {
            return nil
        }
        
        return VCArr[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        //returting nil so on last PageVC it doesnt go in loop. It stops.
        guard nextIndex < VCArr.count else {
//            return VCArr.first
            return nil
        }
        
        guard VCArr.count > nextIndex else {
            return nil
        }
        
        return VCArr[nextIndex]
    }
    
    //responsible for dots at the bottom of page
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCArr.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstVC = viewControllers?.first, let firstVCIndex = VCArr.index(of: firstVC) else {
            return 0
        }
        return firstVCIndex
    }
    
    
}
