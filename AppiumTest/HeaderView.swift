import UIKit
import SnapKit

class HeaderView: UIView {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Button", for: .normal)
        button.backgroundColor = .blue
        
        button.isAccessibilityElement = true
        button.accessibilityLabel = "Button Label"
        button.accessibilityIdentifier = "Button Identifier"
        
        return button
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        
        view.isAccessibilityElement = true
        view.accessibilityLabel = "Background Label"
        view.accessibilityIdentifier = "Background Identifier"
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
        
        self.isAccessibilityElement = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubview(self.backgroundView)
        self.addSubview(self.button)
        self.setNeedsUpdateConstraints()
    }
    
    private var hasUpdatedConstraints = false
    override func updateConstraints() {
        
        if !self.hasUpdatedConstraints {
            
            self.backgroundView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(10)
            }
            
            self.button.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(80)
            }
            
            self.hasUpdatedConstraints = true
        }
        
        super.updateConstraints()
    }
}
