//
//  CameraController.swift
//  Apple-Camera-App
//
//  Created by Chrishon Wyllie on 3/27/17.
//  Copyright © 2017 Chrishon Wyllie. All rights reserved.
//

import UIKit

// This framework is necessary to actually take images
import AVFoundation

// This framework is necessary to save the image to your camera roll
import Photos

class CameraController: UIViewController {
    
    
    // MARK: - Top bar
    
    // TopBar UIVIew that displays the various camera functions
    var topbarView: UIView = {
        let view = UIView()
        
        // Necessary for setting your constraints. Essentially placing the view where ever you want
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    var switchCameraFlashButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // If you have your own custom images that you would like to use for this button...
        //let myCustomFlashImage = UIImage(named: "my_custom_flas_image")
        //button.setImage(myCustomFlashImage, for: .normal)
        
        button.setTitle("flash", for: .normal)
        return button
    }()
    
    var HDRButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("hdr", for: .normal)
        return button
    }()
    
    var liveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("live", for: .normal)
        return button
    }()
    
    var durationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("duration", for: .normal)
        return button
    }()
    
    var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("filter", for: .normal)
        return button
    }()
    
    
    
    
    
    // MARK: - Camera View
    
    // The actual camera view that will capture images
    var cameraView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    
    
    
    
    // MARK: - Bottom bar
    // BottomBar UIView that displays the different kinds of camera options, camera capture button, front/back camera button and photo library
    
    var bottombarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    var cameraOptionsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 100, height: 40)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.allowsMultipleSelection = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
        
    }()
    
    
    
    // Specify as lazy so that this can run UITapGestureRecognizers (when the image is tapped, something happens like a UIButton)
    lazy var photoLibraryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        //This is so that the UIImageView can act as a UIButton and perform some action when tapped
        imageView.isUserInteractionEnabled = true
        
        // this runs the function when tapped                                             // This is the function that is run
        let tappedGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showLastPhotoLibraryImage))
        imageView.addGestureRecognizer(tappedGestureRecognizer)
        
        
        imageView.backgroundColor = .white
        
        return imageView
    }()
    
    var takePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitle("capture", for: .normal)
        
        // If you make an object rounded or circular, this is necessary
        // if you want to avoid having areas outside the object
        // that can still be pressed on
        button.clipsToBounds = true
        
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 6
        button.backgroundColor = .white
        
        button.addTarget(self, action: #selector(didPressTakeAnother), for: .touchUpInside)
        
        return button
    }()
    
    var switchFromFrontOrBackCameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("switch", for: .normal)
        
        
        button.addTarget(self, action: #selector(changeCameraView), for: .touchUpInside)
        
        button.clipsToBounds = true
        
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        return button
    }()
    
    
    
    // This function is quite long. You could separate each "view" and its buttons into separate functions if you like.
    func addViewsAsSubviews() {
        
        view.addSubview(topbarView)
        topbarView.addSubview(switchCameraFlashButton)
        topbarView.addSubview(HDRButton)
        topbarView.addSubview(liveButton)
        topbarView.addSubview(durationButton)
        topbarView.addSubview(filterButton)
        
        
        view.addSubview(cameraView)
        
        
        view.addSubview(bottombarView)
        bottombarView.addSubview(cameraOptionsCollectionView)
        bottombarView.addSubview(photoLibraryImageView)
        bottombarView.addSubview(takePhotoButton)
        bottombarView.addSubview(switchFromFrontOrBackCameraButton)
        
        
        
        // Now we configure the constraints for all the top bar views
        
        topbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topbarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topbarView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        /*
         I find that it is somewhat easier to first configure constraints for the view
         that will be in the center, and then tailor everything else to that view.
         However, there are multiple ways to skin a cat...
         */
        
        
        liveButton.centerXAnchor.constraint(equalTo: topbarView.centerXAnchor).isActive = true
        liveButton.centerYAnchor.constraint(equalTo: topbarView.centerYAnchor).isActive = true
        liveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        //switchCameraFlashButton.leadingAnchor.constraint(equalTo: topbarView.leadingAnchor, constant: 8).isActive = true
        switchCameraFlashButton.trailingAnchor.constraint(equalTo: HDRButton.leadingAnchor, constant: -8).isActive = true
        switchCameraFlashButton.centerYAnchor.constraint(equalTo: topbarView.centerYAnchor).isActive = true
        switchCameraFlashButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        HDRButton.trailingAnchor.constraint(equalTo: liveButton.leadingAnchor, constant: -8).isActive = true
        HDRButton.centerYAnchor.constraint(equalTo: topbarView.centerYAnchor).isActive = true
        HDRButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        durationButton.leadingAnchor.constraint(equalTo: liveButton.trailingAnchor, constant: 8).isActive = true
        durationButton.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -8).isActive = true
        durationButton.centerYAnchor.constraint(equalTo: topbarView.centerYAnchor).isActive = true
        durationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        

        //filterButton.trailingAnchor.constraint(equalTo: topbarView.trailingAnchor, constant: -8).isActive = true
        filterButton.centerYAnchor.constraint(equalTo: topbarView.centerYAnchor).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        

        
        
        
        
        
        
        
        
        // The camera view needs nothing more than its own constraints
        
        cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cameraView.topAnchor.constraint(equalTo: topbarView.bottomAnchor).isActive = true
        cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cameraView.bottomAnchor.constraint(equalTo: bottombarView.topAnchor).isActive = true
        
        
        
        
        
        
        
        
        
        // Set up contraints for all the bottom bar views
        
        bottombarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottombarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottombarView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottombarView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        
        cameraOptionsCollectionView.leadingAnchor.constraint(equalTo: bottombarView.leadingAnchor, constant: 8).isActive = true
        cameraOptionsCollectionView.topAnchor.constraint(equalTo: bottombarView.topAnchor, constant: 8).isActive = true
        cameraOptionsCollectionView.trailingAnchor.constraint(equalTo: bottombarView.trailingAnchor, constant: -8).isActive = true
        cameraOptionsCollectionView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        photoLibraryImageView.leadingAnchor.constraint(equalTo: bottombarView.leadingAnchor, constant: 16).isActive = true
        photoLibraryImageView.centerYAnchor.constraint(equalTo: takePhotoButton.centerYAnchor).isActive = true
        photoLibraryImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        photoLibraryImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        takePhotoButton.centerXAnchor.constraint(equalTo: bottombarView.centerXAnchor).isActive = true
        takePhotoButton.topAnchor.constraint(equalTo: cameraOptionsCollectionView.bottomAnchor, constant: 8).isActive = true
        //takePhotoButton.bottomAnchor.constraint(equalTo: bottombarView.bottomAnchor, constant: -12).isActive = true
        takePhotoButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        takePhotoButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        // Setting the corner radius of an object to half of its width or height will make it rounded
        takePhotoButton.layer.cornerRadius = 30
        
        
        switchFromFrontOrBackCameraButton.trailingAnchor.constraint(equalTo: bottombarView.trailingAnchor, constant: -16).isActive = true
        switchFromFrontOrBackCameraButton.centerYAnchor.constraint(equalTo: takePhotoButton.centerYAnchor).isActive = true
        switchFromFrontOrBackCameraButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        switchFromFrontOrBackCameraButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        switchFromFrontOrBackCameraButton.layer.cornerRadius = 30

        
    }
    
    let reuseIdentifier = "cameraOptionsCell"

    var cameraOptionTitles = ["TIME LAPSE", "SLO-MO", "VIDEO", "PHOTO", "SQUARE", "PANO"]
    
    func configureCameraOptionsCollectionView() {
        
        
        // Use the UICollectionView delegate and datasource functions declared in the extension down below
        cameraOptionsCollectionView.delegate = self
        cameraOptionsCollectionView.dataSource = self
        
        cameraOptionsCollectionView.register(CameraOptionsCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var didTakePhoto: Bool = false
    var didTakeVideo: Bool = false
    
    
    let error: NSError? = nil
    var captureDevice: AVCaptureDevice? = nil
    var captureAudio: AVCaptureDevice? = nil
    var cameraFacing = CameraType.Back

    
    
    
    enum CameraType {
        case Front
        case Back
    }
    
    func changeCameraView() {
        if cameraFacing == CameraType.Back {
            cameraFacing = CameraType.Front
            setUpCameraView()
        } else {
            cameraFacing = CameraType.Back
            setUpCameraView()
        }
    }
    
    func configureDevice() {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
                if device.isFocusModeSupported(.locked) {
                    
                    // The front facing camera does not support this.
                    // A crash occurs if you do not check if the focus mode is supported
                    
                    device.focusMode = .locked
                }
                device.unlockForConfiguration()
            } catch let error {
                print("error attempting to lock for configuration: \(error.localizedDescription)")
            }
        }
    }
    
    fileprivate func setUpCameraView() {
        
        configureDevice()
        
        captureSession?.stopRunning()
        previewLayer?.removeFromSuperlayer()
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
        
        
        if (cameraFacing == CameraType.Back) {
            captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            captureAudio = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
            
        } else {
            
            _ = AVCaptureDeviceDiscoverySession.init(deviceTypes: [.builtInMicrophone, .builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .front)
            
            captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
            captureAudio = AVCaptureDevice.defaultDevice(withDeviceType: .builtInMicrophone, mediaType: AVMediaTypeAudio, position: .unspecified)
        }
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            let audioInput = try AVCaptureDeviceInput(device: captureAudio)
            
            if (error == nil && captureSession?.canAddInput(input) != nil && captureSession?.canAddInput(audioInput) != nil) {
                captureSession?.addInput(input)
                captureSession?.addInput(audioInput)
                stillImageOutput = AVCaptureStillImageOutput()
                stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                
                if (captureSession?.canAddOutput(stillImageOutput) != nil) {
                    captureSession?.addOutput(stillImageOutput)
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                    previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                    cameraView.layer.addSublayer(previewLayer!)
                    captureSession?.startRunning()
                }
            }
        } catch let error {
            print("Something went wrong... \(error.localizedDescription)")
        }
        previewLayer?.frame = self.view.bounds
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func fixOrientation(ForImage image: UIImage) -> UIImage {
        
        if (image.imageOrientation == UIImageOrientation.up) {
            return image
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale);
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
        
    }

    fileprivate func didpressTakePhoto() {
        if let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo) {
            
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) in
                
                if sampleBuffer != nil {
                    
                    let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer!, previewPhotoSampleBuffer: nil)
                    
                    // deprecated
                    //let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                    
                    let image: UIImage?
                    
                    
                    if self.cameraFacing == CameraType.Back {
                        
                        image = self.fixOrientation(ForImage: UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: .right))
                        
                        self.downloadImageToCameraRoll(withCapturedImage: image!)
                        
                        // Update the last image with this image
                        self.photoLibraryImageView.image = image
                        
                    } else {
                        
                        image = self.fixOrientation(ForImage: UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.leftMirrored))
                        
                        self.downloadImageToCameraRoll(withCapturedImage: image!)
                        
                        // Update the last image with this image
                        self.photoLibraryImageView.image = image
                        
                    }
                }
            })
        }
    }
    
    func downloadImageToCameraRoll(withCapturedImage capturedImage: UIImage) {
        
        if didTakePhoto {
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: capturedImage)
            }, completionHandler: { (creationWasSuccessful, error) in
                if creationWasSuccessful {
                    print("image successfully saved to camera roll")
                }
            })
        }
    }
    
    @objc fileprivate func didPressTakeAnother() {
        if didTakePhoto == true {
            
            didTakePhoto = false
        
        } else {
            
            // why not didTakePhoto? Perhaps I should use didTakeMedia overall instead
            didTakePhoto = true
            
            captureSession?.startRunning()
            didpressTakePhoto()
        }
    }
    
    // this will be used when the photoLibraryImageView is tapped on
    var lastPhotoFromLibrary: UIImage?
    
    private func setLastPhotoLibraryImage() {
        
        ///*
        // This is to display the last image in your photo camera roll as the image
        let imgManager = PHImageManager.default()
        var reqOptions: PHImageRequestOptions? {
            didSet {
                if let _reqOptions = reqOptions {
                    _reqOptions.isSynchronous = true
                }
            }
        }
        
        // Get the last image in the array
        // Why first and not last? 
        // Because, we are loading in descending time order
        // So if you took a picture today and one yesterday
        // The one today is added to the array first, then the one yesterday and so on
        let lastAsset = phassetImageArray.first
        
        if lastAsset != nil {
            let targetSize = CGSize(width: 300, height: 300)
            imgManager.requestImage(for: lastAsset!, targetSize: targetSize, contentMode: .aspectFill, options: reqOptions, resultHandler: { (returnedImage, info) in
                self.photoLibraryImageView.image = returnedImage
                self.lastPhotoFromLibrary = returnedImage
            })
        } else {
            print("last asset was nil")
        }
        
    }
    
    func showLastPhotoLibraryImage() {
        
        print("Show last photo")
        
        let singlePhotoController = SinglePhotoViewController()
        
        singlePhotoController.lastPhotoImageView.image = photoLibraryImageView.image
        
        self.present(singlePhotoController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        addViewsAsSubviews()
        
        setLastPhotoLibraryImage()
        
        configureCameraOptionsCollectionView()
        
        setUpCameraView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


// This is for the camera options

extension CameraController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CameraOptionsCell?
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CameraOptionsCell
        
        configureCell(forCell: cell!, withIndexPath: indexPath)
        
        return cell!
    }
    
    func configureCell(forCell cell: CameraOptionsCell, withIndexPath indexPath: IndexPath) {
        cell.optionTitle.text = cameraOptionTitles[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        // If you scroll to the third button (VIDEO), turn the button red, otherwise turn it back to white
        takePhotoButton.backgroundColor = indexPath.item == 2 ? .red : .white
        
    }
    
}

class CameraOptionsCell: UICollectionViewCell {
    
    var optionTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(optionTitle)
        
        optionTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        optionTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
