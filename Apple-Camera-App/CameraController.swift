//
//  CameraController.swift
//  Apple-Camera-App
//
//  Created by Chrishon Wyllie on 3/27/17.
//  Copyright © 2017 Chrishon Wyllie. All rights reserved.
//




// MARK: - Imports
import UIKit

// This framework is necessary to actually take images
import AVFoundation

// This framework is necessary to save the image to your camera roll
import Photos

class CameraController: UIViewController {
    
    
    
    /*
    
    
    
    
    */
    
    
    
    // MARK: - UI Elements
    
    // MARK: - Top bar (and the buttons that will be displayed in it)
    
    // TopBar UIVIew that displays the various camera functions
    var topbarView: UIView = {
        let view = UIView()
        
        // Necessary for setting your constraints. Essentially placing the view where ever you want
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Optional but for the purpose of mimicry...
        view.backgroundColor = .black
        return view
    }()
    
    var switchCameraFlashButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // If you have your own custom images that you would like to use for this button...
        // For example, a flash or thunder icon
        //let myCustomFlashImage = UIImage(named: "my_custom_flas_image")
        //button.setImage(myCustomFlashImage, for: .normal)
        
        button.addTarget(self, action: #selector(changeCameraFlash), for: .touchUpInside)
        
        button.setTitle("flash", for: .normal)
        
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    // These next four buttons do not actually do anything for this demo
    var HDRButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("hdr", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var liveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("live", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var durationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("duration", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("filter", for: .normal)
        button.setTitleColor(.white, for: .normal)
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
    
    // These represent the lines used to line up the shot before taking a picture
    var firstHorizontalLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        return view
    }()
    var secondHorizontalLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        return view
    }()
    var firstVerticalLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        return view
    }()
    var secondVerticalLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
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
        //collectionView.isPagingEnabled = true
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
        
        button.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        
        return button
    }()
    
    var switchFromFrontOrBackCameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("switch", for: .normal)
        
        
        button.addTarget(self, action: #selector(changeCameraView), for: .touchUpInside)
        
        button.clipsToBounds = true
        
        button.setTitleColor(.white, for: .normal)
        
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
        view.addSubview(firstHorizontalLine)
        view.addSubview(secondHorizontalLine)
        view.addSubview(firstVerticalLine)
        view.addSubview(secondVerticalLine)
        
        
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
        
        
        // This will vary with size of the screen. Run this on multiple devices to configure as necessary
        let deviceWidth = UIScreen.main.bounds.width
        print("device width: \(deviceWidth)")
        let widthOfEachButton: CGFloat = deviceWidth / 5
        print("width of each button: \(widthOfEachButton)")
        // let spacingBetween: CGFloat ......
        // I ran this on an iPhone 7 with a device width of 375.0
        // therefore, I calculated the space in between each button to be 2.5
        
       
        switchCameraFlashButton.leadingAnchor.constraint(equalTo: topbarView.leadingAnchor, constant: 2.5).isActive = true
        switchCameraFlashButton.trailingAnchor.constraint(equalTo: HDRButton.leadingAnchor, constant: -2.5).isActive = true
        switchCameraFlashButton.centerYAnchor.constraint(equalTo: topbarView.centerYAnchor).isActive = true
        switchCameraFlashButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        switchCameraFlashButton.widthAnchor.constraint(equalToConstant: widthOfEachButton).isActive = true
        
        HDRButton.leadingAnchor.constraint(equalTo: switchCameraFlashButton.trailingAnchor, constant: 2.5).isActive = true
        HDRButton.trailingAnchor.constraint(equalTo: liveButton.leadingAnchor, constant: -2.5).isActive = true
        HDRButton.centerYAnchor.constraint(equalTo: topbarView.centerYAnchor).isActive = true
        HDRButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        HDRButton.widthAnchor.constraint(equalToConstant: widthOfEachButton).isActive = true
        
        
        liveButton.centerXAnchor.constraint(equalTo: topbarView.centerXAnchor).isActive = true
        liveButton.centerYAnchor.constraint(equalTo: topbarView.centerYAnchor).isActive = true
        liveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        liveButton.widthAnchor.constraint(equalToConstant: widthOfEachButton).isActive = true
        
        
        durationButton.leadingAnchor.constraint(equalTo: liveButton.trailingAnchor, constant: 2.5).isActive = true
        durationButton.trailingAnchor.constraint(equalTo: durationButton.leadingAnchor, constant: -2.5).isActive = true
        durationButton.centerYAnchor.constraint(equalTo: topbarView.centerYAnchor).isActive = true
        durationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        durationButton.widthAnchor.constraint(equalToConstant: widthOfEachButton).isActive = true

        filterButton.leadingAnchor.constraint(equalTo: durationButton.trailingAnchor, constant: 2.5).isActive = true
        filterButton.trailingAnchor.constraint(equalTo: topbarView.trailingAnchor, constant: -2.5).isActive = true
        filterButton.centerYAnchor.constraint(equalTo: topbarView.centerYAnchor).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        filterButton.widthAnchor.constraint(equalToConstant: widthOfEachButton).isActive = true

        
        
        
        
        
        
        
        
        // The camera view needs nothing more than its own constraints
        
        cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cameraView.topAnchor.constraint(equalTo: topbarView.bottomAnchor).isActive = true
        cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cameraView.bottomAnchor.constraint(equalTo: bottombarView.topAnchor).isActive = true
        
        
        
        // Horizontal and vertical lines
        
        // In order to position the horizontal and vertical lines, we need to determine the size of the cameraView
        // Height of topbar: 70
        // Height of bottomBar: 140
        let heightOfCameraView = view.frame.size.height - 210
        
        firstHorizontalLine.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor, constant: view.frame.size.width / 3).isActive = true
        firstHorizontalLine.topAnchor.constraint(equalTo: cameraView.topAnchor).isActive = true
        firstHorizontalLine.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor).isActive = true
        firstHorizontalLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        secondHorizontalLine.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor, constant: -(view.frame.width / 3)).isActive = true
        secondHorizontalLine.topAnchor.constraint(equalTo: cameraView.topAnchor).isActive = true
        secondHorizontalLine.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor).isActive = true
        secondHorizontalLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        firstVerticalLine.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor).isActive = true
        firstVerticalLine.topAnchor.constraint(equalTo: cameraView.topAnchor, constant: heightOfCameraView / 3).isActive = true
        firstVerticalLine.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor).isActive = true
        firstVerticalLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        secondVerticalLine.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor).isActive = true
        secondVerticalLine.topAnchor.constraint(equalTo: cameraView.bottomAnchor, constant: -(heightOfCameraView / 3)).isActive = true
        secondVerticalLine.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor).isActive = true
        secondVerticalLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
        
        
        
        
        
        
        
        
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
        
        // Register the cell that will be used
        cameraOptionsCollectionView.register(CameraOptionsCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    
    // MARK: Camera View variables
    
    // These will be used to actually display the camera
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    // This will be used to capture an image with the button
    var stillImageOutput: AVCaptureStillImageOutput?
    
    
    // Determine if a video was captured or if a video was captured
    // for the purposes of this demonstration, I've chosen not to implement video capture
    var didTakePhoto: Bool = false
    var didTakeVideo: Bool = false
    
    
    let error: NSError? = nil
    
    // This will be used to capture an image
    var captureDevice: AVCaptureDevice? = nil
    
    // by default, set the camera to the one on the rear of the iPhone/ iPad (facing outwards)
    var cameraFacing = CameraType.Back

    
    
    // Used to determine which camera is being used
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
    
    var flashActive: Bool = false
    
    func changeCameraFlash() {
        print("Changing camera flash")
        
        flashActive = !flashActive
        
        do {
            try captureDevice?.lockForConfiguration()
        } catch let error {
            print("error locking configuration for flash mod: \(error.localizedDescription)")
            return
        }
        
        captureDevice?.flashMode = flashActive ? .on : .off
        
        flashActive ? switchCameraFlashButton.setTitle("Flash On", for: .normal) :
                        switchCameraFlashButton.setTitle("Flash Off", for: .normal)
        
        captureDevice?.unlockForConfiguration()
        
    }
    
    
    fileprivate func setUpCameraView() {
        
        
        captureSession?.stopRunning()
        previewLayer?.removeFromSuperlayer()
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
        
        
        if (cameraFacing == CameraType.Back) {
            captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            
        } else {
            
            
            captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        }
        
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            if (error == nil && captureSession?.canAddInput(input) != nil)  {
                
                captureSession?.addInput(input)

                // this has been depereated for iOS 10 and will likely throw a warning for you
                // however for the time being, the warning can be safely ignored until Apple no longer supports it
                // The outputSettings are not supported in the the suggested fix: AVCapturePhotoOutput just yet
                stillImageOutput = AVCaptureStillImageOutput()
                
                //let x = AVCapturePhotoOutput()
            
                // Allows you to retrieve a JPEG image
                stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                
                // Now finally add the stillImageOutput to the captureSession
                if (captureSession?.canAddOutput(stillImageOutput) != nil) {
                    captureSession?.addOutput(stillImageOutput)
                    
                    // Configure the preview Layer that will display the camera
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    
                    
                    previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                    previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                    cameraView.layer.addSublayer(previewLayer!)
                    
                    // Begin the session
                    captureSession?.startRunning()
                }
            }
        } catch let error {
            print("Something went wrong... \(error.localizedDescription)")
        }
        
        // Specify the frame of the preview layer which is ultimately displaying the camera
        previewLayer?.frame = self.view.bounds
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // This will fix an issue where captured images may be rotated incorrectly after capturing an image
    
    func fixOrientation(ForImage image: UIImage) -> UIImage {
        
        // If the image was the correct orientation, then proceed and return the image
        if (image.imageOrientation == UIImageOrientation.up) {
            return image
        }
        
        // however, if it was not...
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
        
    }

    
    
    
    // Download the image to the camera roll once it is taken
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
    
    func takePhoto() {
        didTakePhoto = true
        
        captureSession?.startRunning()
        
       
        
        // Get the current camera connection
        if let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo) {
            
            // Specify what orientation you'd like the returned image to be
            videoConnection.videoOrientation = AVCaptureVideoOrientation.portrait
            
            // Capture image...
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer, error) in
                
                // safely check that sampleBuffer is not nil
                if sampleBuffer != nil {
                    
                    // Convert the the sampleBuffer into CFData
                    let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer!, previewPhotoSampleBuffer: nil)
                    
                    // deprecated
                    //let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    
                    // Convert the CGData into a CGIMage
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                    
                    let image: UIImage?
                    
                    // now is the time to fix the orientation if necessary
                    if self.cameraFacing == CameraType.Back {
                        
                        image = self.fixOrientation(ForImage: UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: .right))
                        
                        // This is optional, but to mimic the nature of the Camera app, taking an image automatically downloads the image to the camera roll
                        self.downloadImageToCameraRoll(withCapturedImage: image!)
                        
                        // Update the last image with this image
                        self.photoLibraryImageView.image = image
                        
                    } else {
                        
                        image = self.fixOrientation(ForImage: UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.leftMirrored))
                        
                        self.downloadImageToCameraRoll(withCapturedImage: image!)
                        
                        self.photoLibraryImageView.image = image
                        
                    }
                }
            })
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
    
    
    
    /*
     
     Provide your own implementation for when a specific cell is tapped
     
     */
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        //indexPath.item == 2 ? reconfigureViewsForVideo(withIndexPath: indexPath) : reconfigureViewsForPicture(withIndexPath: indexPath)
        
        // If you scroll to the third button (VIDEO), turn the button red, otherwise turn it back to white
        takePhotoButton.backgroundColor = indexPath.item == 2 ? .red : .white
        
        // Remove the horizontal and vertical lines
        let lines: [UIView] = [firstHorizontalLine, secondHorizontalLine, firstVerticalLine, secondVerticalLine]
        for line in lines {
            line.isHidden = indexPath.item == 2 ? true : false
        }
    }
}












