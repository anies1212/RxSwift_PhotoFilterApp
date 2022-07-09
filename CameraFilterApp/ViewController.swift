//
//  ViewController.swift
//  CameraFilterApp
//
//  Created by anies1212 on 2022/07/09.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        button.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController, let photosVC = navC.viewControllers.first as? PhotoSelectionViewController else {return}
        photosVC.selectedPhoto.subscribe(onNext: { photo in
            self.imageView.image = photo
            self.button.isHidden = false
        }).disposed(by: bag)
    }
    
    @IBAction func filterPhoto(){
        guard let sourceImage = self.imageView.image else {return}
        FilterService().applyFilter(to: sourceImage).subscribe(onNext: { filteredImage in
            DispatchQueue.main.async {
                self.imageView.image = filteredImage
            }
        }).disposed(by: bag)
    }
    
    
}

