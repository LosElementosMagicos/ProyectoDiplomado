//
//  ItemProfilePageViewController.swift
//  Lend It
//
//  Created by Daniel Esteban Salinas Suárez on 1/10/19.
//  Copyright © 2019 Daniel Esteban Salinas Suárez. All rights reserved.
//

import UIKit

class ItemProfilePageViewController: UIPageViewControllerWithOverlayIndicator , UIPageViewControllerDataSource {
    
    // Array of images to display
    var photoData: [UIImage] = [UIImage(named: "add-camera.png")!,
                                UIImage(named: "icon_item.png")!,
                                UIImage(named: "icon_me.png")!]
    
    /// Configures self as the data source and first-presented view controller.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Install this class as the data source
        dataSource = self
        // Present first PhotoViewController
        let firstPhotoVC = newPhotoViewControllerAtIndex(0)
        setViewControllers([firstPhotoVC], direction: .forward, animated: true, completion: nil)
    }
    
    func newPhotoViewControllerAtIndex(_ index: Int) -> ItemProfilePhotoViewController {
        let photoViewController = storyboard?.instantiateViewController(withIdentifier: "PhotoViewController") as! ItemProfilePhotoViewController
        photoViewController.dataObject = self.photoData[index]
        return photoViewController
    }
    
    // Returns the ItemProfilePhotoViewController for the given index
    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> ItemProfilePhotoViewController? {
        if (self.photoData.count == 0) || (index >= self.photoData.count) {
            return nil
        }
        // Create a new view Controller and pass suitable data
        let photoViewController = storyboard.instantiateViewController(withIdentifier: "PhotoViewController") as! ItemProfilePhotoViewController
        photoViewController.dataObject = self.photoData[index]
        return photoViewController
    }

    // Returns index of given view controller by comparing its dataObject with items on photoData array
    func indexOfViewController(_ viewController: ItemProfilePhotoViewController) -> Int {
        return photoData.index(of: viewController.dataObject!) ?? NSNotFound
    }
    
    // MARK: - Page View Controller Data Source
    
    // Returns the next view controller, or `nil` if there is no such controller.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! ItemProfilePhotoViewController)
        print(index)
        if (index == NSNotFound) {
            return nil
        }
        index += 1
        print(index)
        if index == self.photoData.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    // Returns the previous view controller, or `nil` if there is no such controller.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! ItemProfilePhotoViewController)
        if ((index == 0) || index == NSNotFound) {
            return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    // Returns the number of pages to represent in the `UIPageControl` page indicator. Only wotks with scroll
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.photoData.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

