//
//  SinglePhotoViewController.swift
//  Apple-Camera-App
//
//  Created by Chrishon Wyllie on 3/27/17.
//  Copyright © 2017 Chrishon Wyllie. All rights reserved.
//

import UIKit

// This framework is necessary to save the image to your camera roll
import Photos

class SinglePhotoViewController: UIViewController {
    
    // MARK: - ReuseIdentifier for photos collection view
    let reuseIdentifier = "photoCell"
    
    
    
    // MARK: - UI Elements
    var topbarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelDidTapped(_:)), for: .touchUpInside)
        button.setTitle("Camera", for: .normal)
        return button
    }()

    // Specify as lazy to use UITapGestureRecognizer
    lazy var lastPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        
        // Absolutely neecssary if your using your own constraints and not the normal CGRect(origin: CGPoint, size: CGSize) way
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFit
        
        imageView.isUserInteractionEnabled = true
        
        
        // When the UIImageView is tapped, hide or show the bars
        let tappedGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideTopAndbottomBars(_:)))
        imageView.addGestureRecognizer(tappedGestureRecognizer)
        
        return imageView
    }()
    
    var bottombarView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Optional
        view.backgroundColor = .white
        
        return view
    }()
    
    var photosCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        // Place 1 (pixel?) in between each cell
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        // Make the collectionView display and scroll the cells horizontally
        layout.scrollDirection = .horizontal
        
        // Specify the size of each cell. Change as you see fit, but remember to update the actual size of the UICollectionView in addAsSubviews()
        layout.itemSize = CGSize(width: 30, height: 50)
        
        
        // Instantiate the UICollectionView with the layout object. The frame can be CGRect.zero for now since we will specify our own layout constraints
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // Optional
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        
        // Optional
        collectionView.allowsMultipleSelection = true
        
        
        // Absolutely neecssary if your using your own constraints and not the normal CGRect(origin: CGPoint, size: CGSize) way
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
        
    }()
    
    
    // MARK - Functions
    
    var barsHidden = false
    
    func hideTopAndbottomBars(_ sender: Any) {
        
        print("hiding or unhiding")
        
        // Set to whatever it WASN'T before
        topbarView.isHidden = !barsHidden
        bottombarView.isHidden = !barsHidden
    
        barsHidden = !barsHidden
        
        
    }
    
    // Configure constraints for each UI Element and specify where you'd like them to be placed
    private func addAsSubviews() {
        
        
        view.addSubview(lastPhotoImageView)
        
        // This is added after the lastphotoImageView because it will get covered otherwise
        view.addSubview(topbarView)
        topbarView.addSubview(cancelButton)
        
        view.addSubview(bottombarView)
        bottombarView.addSubview(photosCollectionView)
        
        
        topbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topbarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topbarView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        
        cancelButton.centerYAnchor.constraint(equalTo: topbarView.centerYAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: topbarView.leadingAnchor, constant: 8).isActive = true
        
        
        lastPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lastPhotoImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lastPhotoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lastPhotoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        bottombarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottombarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottombarView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottombarView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        photosCollectionView.leadingAnchor.constraint(equalTo: bottombarView.leadingAnchor).isActive = true
        photosCollectionView.topAnchor.constraint(equalTo: bottombarView.topAnchor).isActive = true
        photosCollectionView.trailingAnchor.constraint(equalTo: bottombarView.trailingAnchor).isActive = true
        photosCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
    }
    
    private func setupPhotosCollectionView() {
        
        // Make this collectionView conform to the delegate and datasource functions of UICollectionView
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        // Register the cell you'd like to use
        photosCollectionView.register(PhotosCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Finally reload the data so that all the images appear
        photosCollectionView.reloadData()
        
    }
    
    // Called to bring back the camera view controller
    func cancelDidTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addAsSubviews()
        
        setupPhotosCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



// MARK: - UICollectionView delegate and datasource
// This is for the photos collection view that will be in the bottom bar

extension SinglePhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // declared and configured in AppDelegate.swift
        return phassetImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotosCell?
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotosCell
        
        let asset = phassetImageArray[indexPath.row]
        
        cell?.asset = asset
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let asset = phassetImageArray[indexPath.item]
        
        // This will be used to retrieve a specific UIImage when a cell is tapped
        let imgManager = PHImageManager.default()
        
        // You can configure this however you wish
        let reqOptions = PHImageRequestOptions()
        
        reqOptions.isSynchronous = true
        
        // This is a "magic number" I've chosen
        let width = 300
        let height = 300
        
        let thumbnailSize: CGSize = CGSize(width: width, height: height)
        imgManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: reqOptions, resultHandler: { (image, info) in
            // when a cell is tapped, set the main image to the image retrieved from that PHAsset
            self.lastPhotoImageView.image = image
        })
        
        // Finall scroll to that cell
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
    }
    
}




class PhotosCell: UICollectionViewCell {
    
    var photo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let imgManager = PHImageManager.default()
    
    var reqOptions: PHImageRequestOptions? {
        didSet {
            if let _reqOptions = reqOptions {
                _reqOptions.isSynchronous = true
            }
        }
    }
    
    var asset: PHAsset? {
        didSet {
            if let _asset = asset {
                
                let width = 300 //self.frame.size.width
                let height = 300 //self.frame.size.height
                
                let thumbnailSize: CGSize = CGSize(width: width, height: height)
                imgManager.requestImage(for: _asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: reqOptions, resultHandler: { (image, info) in
                    self.photo.image = image
                })
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photo)
        
        photo.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        photo.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        photo.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        photo.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        photo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
