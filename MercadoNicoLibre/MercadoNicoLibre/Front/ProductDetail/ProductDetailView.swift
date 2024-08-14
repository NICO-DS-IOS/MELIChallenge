import UIKit
import YCarousel

final class ProductDetailView : UIView {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    private let carouselView: CarouselView = {
        let carouselView = CarouselView(views: [])
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        return carouselView
    }()
    
    private var title = {
        let label = UILabel()
        label.numberOfLines = 5
        return label
    }()
    
    private var images:[String]? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubViews()
    }
    
    private func setupSubViews() {
        self.backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        [carouselView, title].forEach{ view in
            stackView.addArrangedSubview(view)
            NSLayoutConstraint.activating([view.relativeTo(self, positioned: .width(margin: 20))])
        }
        
        NSLayoutConstraint.activating([
            scrollView.relativeToParent(.top() + .left() + .right() + .bottom()),
            stackView.relativeToParent(.top() + .left() + .right() + .bottom())
        ])
    }
    
    func setData(data:ProductViewObject) {
        images = data.pictures
        carouselView.dataSource = self
        
        title.text = data.title
        
        data.attributes.forEach{ attribute in
            addProductData(productData: attribute)
        }
    }
                                     
    private func addProductData(productData:ProductInfoViewObject) {
        stackView.addArrangedSubview(UIComponents.createInfoRow(description: productData.description, value: productData.value))
    }
}

extension ProductDetailView: CarouselViewDataSource {
    func carouselView(pageAt index: Int) -> UIView {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        if let safeUrl = URL(string: images?[index] ?? "")  {
            imageView.load(url: safeUrl)
        }
        
        return imageView
    }

    var numberOfPages: Int {
        images?.count  ?? 0
    }
}
