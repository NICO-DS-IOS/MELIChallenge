import UIKit
import MBProgressHUD

final class SearchViewController: UITableViewController {
    
    let searchBarController = UISearchController(searchResultsController: nil)
    
    var viewModel: SearchViewModel? {
        didSet {
            connectUIToModel()
        }
    }
    
    let helperLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLayoutConstraint.activating([
            helperLabel.relativeToParent(.centerX() + .top(margin: self.view.frame.height/5)),
        ])
    }
    
    func setupView() {
        self.view.addSubview(helperLabel)
        tableView.register(SearchCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        setSearchBarUI()
    }
    
    func setSearchBarUI() {
        searchBarController.searchBar.delegate = self
        searchBarController.searchBar.sizeToFit()
        navigationItem.searchController = searchBarController
    }
    
    func connectUIToModel() {
        guard let model = viewModel else { return }
        
        model.setViewTitle.bind { [weak self] value in
            self?.title = value
        }
        
        model.showLoading.bind { [weak self] in
            guard let safeView = self?.view  else { return }
            MBProgressHUD.showAdded(to: safeView, animated: true)
        }
        
        model.hideLoading.bind { [weak self] in
            guard let safeView = self?.view  else { return }
            MBProgressHUD.hide(for: safeView, animated: true)
        }
        
        model.updateStatusMessage.bind { [weak self] visible, value in
            self?.helperLabel.isHidden = !visible
            self?.helperLabel.text = value
        }
        
        model.reloadView.bind { [weak self] in
            self?.tableView.reloadData()
        }
        
        model.navigateToDetailView.bind { [weak self]  data in
            guard let safeData = data else { return }
            self?.navigationController?.pushViewController(ScreenFactory.createDetailViewController(data: safeData), animated: true)
        }
        
        model.showItemLoadError.bind{ [weak self] message in
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            self?.present(alert, animated: true)
        }
    }
}

extension SearchViewController { // UITableViewDatasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getResultsCount() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let concreteCell =  cell as? SearchCell, let data = viewModel?.getResultAt(index: indexPath.row) {
            concreteCell.setData(data: data)
        }
        return cell
    }
}

extension SearchViewController { // UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = viewModel?.getResultAt(index: indexPath.row) else {return}
        viewModel?.onItemTapped(item:data)
    }
}

extension SearchViewController : UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            viewModel?.onSearchTextChanged(text: searchText)
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            viewModel?.onSearchRequested()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.endEditing(true)
            searchBar.text = String()
        }
}

