import UIKit

final class SearchCell : UITableViewCell {
    
    private enum K {
        static let margin: CGFloat = 16
        static let imageHeight: CGFloat = 122
    }
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }()
    
    private let priceLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .gray
        return label
    }()
    
    private let thumbnailView:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        //image.layer.cornerRadius = K.imageHeight/3
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        accessoryView = UIImageView(image: UIImage(systemName: "chevron.right")?.withTintColor(.systemBlue))
        [thumbnailView,titleLabel, priceLabel].forEach{ view in
            contentView.addSubview(view)
        }
        
        let imageSizeConstraints = thumbnailView.relativeToSelf(.constantHeight(K.imageHeight) + .constantWidth(K.imageHeight * 2/3))
        
        NSLayoutConstraint.activating([
            imageSizeConstraints,
            thumbnailView.relativeToParent(.top(margin: K.margin ) + .bottom(margin: K.margin ) + .left(margin: K.margin)),
            titleLabel.relativeToParent(.top(margin: K.margin) + .right(margin: K.margin)),
            titleLabel.relativeToUpperSibling(.toRight(spacing: K.margin)),
            priceLabel.relativeToUpperSibling(.below(spacing: K.margin/2)),
            priceLabel.relativeTo(thumbnailView, positioned: .toRight(spacing: K.margin))
        ])
    }
    
    func setData(data:SearchViewObject) {
        titleLabel.text = data.title
        priceLabel.text = data.price
        if let safeUrl = URL(string: data.thumbNailUrl) {
            thumbnailView.load(url: safeUrl)
        } else {
            thumbnailView.backgroundColor = .gray
        }
    }
}
