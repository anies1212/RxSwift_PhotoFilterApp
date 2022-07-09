//
//  PhotoSelectionViewController.swift
//  CameraFilterApp
//
//  Created by anies1212 on 2022/07/09.
//
import Foundation
import UIKit
import Photos
import RxSwift

class PhotoSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var images = [PHAsset]()
    
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    
    var selectedPhoto: Observable<UIImage> {
        return self.selectedPhotoSubject.asObservable()
    }
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func populatePhotos(){
        PHPhotoLibrary.requestAuthorization({[weak self] status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: .image, options: nil)
                assets.enumerateObjects({(object, count, stop) in
                    self?.images.append(object)
                })
            }
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
            
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCollectionViewCell
        let asset = images[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: CGSize(width: 128, height: 128), contentMode: .aspectFit, options: nil) { image, _ in
            DispatchQueue.main.async {
                cell.photo.image = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedAsset = self.images[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { image, info in
            guard let info = info else {
                return
            }
            let degratedImage = info["PHImageResultIsDegradedKey"] as! Bool
            if !degratedImage {
                if let image = image {
                    self.selectedPhotoSubject.onNext(image)
                    self.dismiss(animated: true)
                }
            }
        }
        
        
    }
}
