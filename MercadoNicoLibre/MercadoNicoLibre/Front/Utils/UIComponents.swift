import UIKit

struct UIComponents {
    
    static func createInfoRow(description:String, value:String, spacing:CGFloat = 25) -> UIView {
        let infoRow = UIStackView()
        
        infoRow.distribution = .fillEqually
        infoRow.axis = .horizontal
        infoRow.alignment = .center
        infoRow.spacing = spacing
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.textAlignment = .right
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.numberOfLines = 3
        
        infoRow.addArrangedSubview(descriptionLabel)
        infoRow.addArrangedSubview(valueLabel)
        
        return infoRow
    }
    
}
