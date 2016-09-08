//
//  CFAnnotationDetailViewController.swift
//  CF Finder
//
//  Created by Duc Nguyen on 9/7/16.
//  Copyright © 2016 Duc Nguyen. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Contacts

class CFAnnotationDetailViewController: CFRootViewController, UIScrollViewDelegate {
    
    let kOtherCFCellIdentifier = "OtherCFCellIdentifier"
    let kDetailCFCellIdentifier = "DetailCFCellIdentifier"
    
    var userLocation: CLLocationCoordinate2D!
    var annotation: CFMapAnnotation!
    var nearAnnotations: NSArray!
    
    @IBOutlet weak var actionBarButton: UIBarButtonItem!
    @IBOutlet weak var categoryIconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var otherCFTableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var isRegisterNotification: Bool = false
    private var kvoContext: UInt8 = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Navigation Bar Title
        self.title = self.annotation.name as String
        
        // Add UIBarButtonItem events
        self.actionBarButton.target = self
        self.actionBarButton.action = #selector(CFAnnotationDetailViewController.actionBarButtonPressed(_:))
        
        // Fonts
        self.nameLabel.font = UIFont(name: constants.FONT_HELVETICA_MEDIUM, size: 16)!
        self.addressLabel.font = UIFont(name: constants.FONT_HELVETICA_REGULAR, size: 12)!
        
        // Text Color
        self.nameLabel.textColor  = UIColor.whiteColor()
        self.addressLabel.textColor = self.constants.UIColorFromRGB(self.constants.RGB_GRAY)
        
        // Set text
        self.nameLabel.text = "\(self.annotation.name)\(self.annotation.categoryName)"
        self.addressLabel.text = self.annotation.getAddressString
        
        // Disable Other CF scroll bounces
        self.otherCFTableView.bounces = false
        
        // Icon
        self.categoryIconImageView.image = self.annotation.categoryIcon ?? UIImage(named: "unknown")!
        self.categoryIconImageView.layer.cornerRadius = 5
        self.categoryIconImageView.clipsToBounds = true
        self.categoryIconImageView.backgroundColor = self.constants.UIColorFromRGB(constants.RGB_GRAY)
        
        // Scroll View
        self.imagesScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width * 2, self.imagesScrollView.frame.size.height)
        self.imagesScrollView.bounces = false
        self.imagesScrollView.pagingEnabled = true
        self.imagesScrollView.showsHorizontalScrollIndicator = false
        self.imagesScrollView.showsVerticalScrollIndicator = false
        self.imagesScrollView.directionalLockEnabled = true
        self.imagesScrollView.alwaysBounceVertical = false
        self.imagesScrollView.scrollsToTop = false
        self.imagesScrollView.delegate = self
        for page in 0..<self.pageControl.numberOfPages {
            let imageView = UIImageView(frame: self.view.frame)
            imageView.image = UIImage(named: "image\(page)")!
            imageView.center = CGPointMake((self.view.frame.size.width * (0.5 + CGFloat(page))), self.imagesScrollView.center.y)
            self.imagesScrollView.addSubview(imageView)
        }
        
        if self.isRegisterNotification == false {
            print("register one time")
            self.isRegisterNotification = true
            //self.view.addObserver(self, forKeyPath: "frame", options: [.New, .Old], context: &kvoContext)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        // self.view.removeObserver(self, forKeyPath: "frame")
    }
    
    // MARK: - Actions
    
    func actionBarButtonPressed(button: UIBarButtonItem) {
        
        let street = self.annotation.getAddressString
        
        // event
        let postalAdress = CNMutablePostalAddress()
        postalAdress.street = street
        let streetName = self.annotation.name
        let postalContact = CNLabeledValue(label: streetName as String, value: postalAdress)
        let urlAddressContact = CNLabeledValue(label: "map url", value: "http://maps.apple.com/maps?address=\(street)")
        let contact = CNMutableContact()
        contact.contactType = .Person
        contact.organizationName = self.annotation.name as String
        contact.departmentName = street
        contact.postalAddresses = [postalContact]
        contact.urlAddresses = [urlAddressContact]
        // create path
        let fileManager = NSFileManager.defaultManager()
        let directory = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!.path!
        let path = directory.stringByAppendingString("/\(street).loc.vcf")
        let error: NSError? = nil
        let contactData = try! CNContactVCardSerialization.dataWithContacts([contact])
        if error == nil {
            contactData.writeToFile(path, atomically: true)
            let url = NSURL.fileURLWithPath(path)
            let acty = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.presentViewController(acty, animated: true, completion: { _ in })
        }
    }
    
    // MARK: - KVO
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &kvoContext {
            if let mychange =  change {
                
            let oldRect = mychange[NSKeyValueChangeOldKey]?.CGRectValue() ?? CGRectZero
            let newRect = mychange[NSKeyValueChangeNewKey]?.CGRectValue() ?? CGRectZero
            
            if !CGRectEqualToRect(newRect, oldRect) {
                self.imagesScrollView.contentSize = CGSizeMake(newRect.size.width * 2, self.imagesScrollView.frame.size.height)
                for page in 0..<self.pageControl.numberOfPages {
                    let imageView = self.imagesScrollView.subviews[page]
                    var frame = imageView.frame
                    frame.size.width = newRect.size.width
                    imageView.frame = frame
                    imageView.center = CGPointMake((newRect.size.width * (0.5 + CGFloat(page))), self.imagesScrollView.center.y)
                    self.imagesScrollView.setContentOffset(CGPointMake((self.imagesScrollView.bounds.size.width * CGFloat(self.pageControl.currentPage + 1)), 0), animated: true)
                }
                }
            }
        }
    }
    
    
    // MARK: - PageControl
    
    @IBAction func pageControlValueChanged(sender: AnyObject) {
        self.imagesScrollView.setContentOffset(CGPointMake((self.imagesScrollView.bounds.size.width * CGFloat(self.pageControl.currentPage)), 0), animated: true)
        self.pageControl.currentPage -= 1
    }
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.isEqual(self.imagesScrollView) {
            let pageWidth: CGFloat = self.imagesScrollView.frame.size.width
            let actualPage: Double = Double(self.imagesScrollView.contentOffset.x) / Double(pageWidth)
            self.pageControl.currentPage = lround(actualPage)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.isEqual(self.otherCFTableView) {
            return 60
        }
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // table detail
        if tableView.isEqual(self.detailTableView) {
            if indexPath.row == 1 {
                // phone call
                let cleanedPhoneNumber = (self.annotation.formattedPhone!.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "0123456789-+()").invertedSet) as NSArray).componentsJoinedByString("")
                let phoneURL = NSURL(string: "tel:\(cleanedPhoneNumber)")!
                if !UIApplication.sharedApplication().canOpenURL(phoneURL) || !UIApplication.sharedApplication().openURL(phoneURL) {
                    self.showMessageWithTitle("Sorry", message: "This device cannot do calls on its own")
                }
            }
            else if indexPath.row == 0 {
                // direction
                self.getDirectionFrom(self.userLocation, coffeeLocation: self.annotation.coordinate)
            }
        }
        else {
            // table other coffee shop
            let mapAnnotation = self.nearAnnotations[indexPath.row] as! CFMapAnnotation
            self.annotation = mapAnnotation
            self.viewDidLoad()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(self.otherCFTableView) {
            return self.nearAnnotations.count
        }
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.isEqual(self.otherCFTableView) {
            let cell = tableView.dequeueReusableCellWithIdentifier(kOtherCFCellIdentifier) as! OtherCFTableViewCell
            let mapAnnotation = self.nearAnnotations[indexPath.row] as! CFMapAnnotation
            cell.nameLabel.text = mapAnnotation.name as String
            cell.addressLabel.text = mapAnnotation.address as String
            cell.categoryIconImageView.image = mapAnnotation.categoryIcon ?? UIImage(named: "unknown")!
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(kDetailCFCellIdentifier) as! DetailCFTableViewCell
        cell.leftLabel.text = indexPath.row == 0 ? "Get directions" : "Make a Call"
        cell.rightLabel.text = indexPath.row == 0 ? "" : self.annotation.formattedPhone as? String ?? "+00 000 000 0000"
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return tableView.isEqual(self.otherCFTableView) ? "Other CFs in 1 mile" as String : ""
    }
}