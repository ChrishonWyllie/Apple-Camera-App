//
//  SinglePhotoViewController.swift
//  Apple-Camera-App
//
//  Created by Chrishon Wyllie on 3/27/17.
//  Copyright © 2017 Chrishon Wyllie. All rights reserved.
//

import UIKit
import Photos

class SinglePhotoViewController: UIViewController {
    
    let reuseIdentifier = "photoCell"
    
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

    var lastPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    var bottombarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    var photosCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 30, height: 50)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        collectionView.allowsMultipleSelection = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
        
    }()
    
    private func addAsSubviews() {
        
        view.addSubview(topbarView)
        topbarView.addSubview(cancelButton)
        
        view.addSubview(lastPhotoImageView)
        
        view.addSubview(bottombarView)
        bottombarView.addSubview(photosCollectionView)
        
        
        topbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topbarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topbarView.bottomAnchor.constraint(equalTo: lastPhotoImageView.topAnchor).isActive = true
        topbarView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        cancelButton.centerYAnchor.constraint(equalTo: topbarView.centerYAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: topbarView.leadingAnchor, constant: 8).isActive = true
        
        
        lastPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lastPhotoImageView.topAnchor.constraint(equalTo: topbarView.bottomAnchor).isActive = true
        lastPhotoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lastPhotoImageView.bottomAnchor.constraint(equalTo: bottombarView.topAnchor).isActive = true
        
        
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
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        photosCollectionView.register(PhotosCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        photosCollectionView.reloadData()
        
    }
    
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



// This is for the

extension SinglePhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        
        let imgManager = PHImageManager.default()
        
        let reqOptions = PHImageRequestOptions()
        
        reqOptions.isSynchronous = true
        
        let width = 300
        let height = 300
        
        let thumbnailSize: CGSize = CGSize(width: width, height: height)
        imgManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: reqOptions, resultHandler: { (image, info) in
            self.lastPhotoImageView.image = image
        })
        
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
