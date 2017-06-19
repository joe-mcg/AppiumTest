import UIKit
import SnapKit

class CollectionView: UICollectionView {
    
    private let headerView: UIView
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, headerView: UIView) {
        self.headerView = headerView
        super.init(frame: frame, collectionViewLayout: layout)
        self.isAccessibilityElement = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var accessibilityElements: [Any]? {
        get {
            return [self.headerView]
        }
        set {
            
        }
    }
}

class ViewController: UIViewController {
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = CollectionView(frame: .zero, collectionViewLayout: self.flowLayout, headerView: self.headerView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    fileprivate var headerViewConstraint: Constraint?
    private lazy var headerView: HeaderView = {
        let view = HeaderView()
        view.backgroundColor = .red
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collectionView)
        self.collectionView.addSubview(self.headerView)
        self.view.setNeedsUpdateConstraints()
    }
    
    private var hasUpdatedConstraints = false
    override func updateViewConstraints() {
        
        if !self.hasUpdatedConstraints {
         
            self.collectionView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            self.headerView.snp.makeConstraints { make in
                make.top.width.centerX.equalTo(self.view)
                self.headerViewConstraint = make.height.equalTo(self.view.snp.width).constraint
            }
            
            self.hasUpdatedConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.contentInset.top = self.collectionView.bounds.size.width
        self.collectionView.collectionViewLayout.invalidateLayout()
        DispatchQueue.main.async {
            self.updateHeroViewFrame(self.collectionView)
        }
    }
    
    fileprivate func updateHeroViewFrame(_ scrollView: UIScrollView) {
        
        let additionalHeight = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        self.headerViewConstraint?.update(offset: additionalHeight)
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateHeroViewFrame(scrollView)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .yellow
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {

}
