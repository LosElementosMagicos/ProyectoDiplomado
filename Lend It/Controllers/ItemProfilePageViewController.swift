//
//  ItemProfilePageViewController.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 1/10/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit

class ItemProfilePageViewController: UIPageViewControllerWithOverlayIndicator , UIPageViewControllerDataSource {
    
    var index = 0
    var photoData: [UIImage] = [UIImage(named: "add-camera.png")!,
                                UIImage(named: "icon_item.png")!,
                                UIImage(named: "icon_me.png")!]
    
    /// Configures self as the data source, and installs the page indicator and first-presented view controller.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Install this class as the data source
        dataSource = self
        
        // Configure page indicator dot colors
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [ItemProfilePageViewController.self])
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        
        // Present first PhotoViewController
        let firstPhotoVC = newPhotoViewControllerAtIndex(0)
        setViewControllers([firstPhotoVC], direction: .forward, animated: true, completion: nil)
    }
    
    func newPhotoViewControllerAtIndex(_ index: Int) -> ItemProfilePhotoViewController {
        let photoViewController = storyboard?.instantiateViewController(withIdentifier: "PhotoViewController") as! ItemProfilePhotoViewController
        photoViewController.dataObject = self.photoData[index]
        return photoViewController
    }
    
    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> ItemProfilePhotoViewController? {
        // Return the dataViewController for the given index
        if (self.photoData.count == 0) || (index >= self.photoData.count)
        {
            return nil
        }
        print("viewcontrolleratindex index = \(index)")
        // Create a new view Controller and pass suitable data
        let photoViewController = storyboard.instantiateViewController(withIdentifier: "PhotoViewController") as! ItemProfilePhotoViewController
        photoViewController.dataObject = self.photoData[index]
        return photoViewController
    }

    func indexOfViewController(_ viewController: ItemProfilePhotoViewController) -> Int {
        print("indexofVC \(photoData.index(of: viewController.dataObject!) ?? NSNotFound)")
        return photoData.index(of: viewController.dataObject!) ?? NSNotFound
    }
    
    
    // MARK: - Page View Controller Data Source
    
    // Returns the _next_ view controller, or `nil` if there is no such controller.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index2 = self.indexOfViewController(viewController as! ItemProfilePhotoViewController)
        print(index2)
        if (index2 == NSNotFound) {
            return nil
        }
        index2 += 1
        print(index2)
        if index2 == self.photoData.count {
            return nil
        }
        return self.viewControllerAtIndex(index2, storyboard: viewController.storyboard!)
    }
    
    // Returns the _previous_ view controller, or `nil` if there is no such controller.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index2 = self.indexOfViewController(viewController as! ItemProfilePhotoViewController)
        if ((index2 == 0) || index2 == NSNotFound) {
            return nil
        }
        index2 -= 1
        return self.viewControllerAtIndex(index2, storyboard: viewController.storyboard!)
    }
    
    // Returns the number of pages to represent in the `UIPageControl` page indicator. Only wotks with scroll
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.photoData.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

