//
//  ViewController.swift
//  NewsTestApp
//
//  Created by shizo663 on 25.02.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Properties -
    var newsData: NewsModel?
    var newsDataArray: [Article] = []
    var sourcesData: [Sources] = []
    let countryDataNames: [String] = ["ae","ar","au","be","bg","br","ca","ch","cn","co","cu","cz","de","eg","eg","fr","gb","gr","hk","hu","id","ie","il","in","it","jp","kr","lt","lv","ma","mx","my","ng","nl","no","nz","ph","pl","pt","ro","rs","ru","sa","se","sg","si","sk","th","tr","tw","ua","us","ve","za",]
    let categoryDataNames: [String] = ["entertainment", "sports", "general", "health", "science", "business", "technology"]
    var sortedBy: Bool = true
    var searchNow: Bool = false
    var toolBar = UIToolbar()
    var picker = UIPickerView()
    var currentPage = 1
    var currentCountry = "us"
    var currentCategory = "general"
    var quary = ""
    let networkManager = NetworkManager()
    let refreshControl = UIRefreshControl()
    //MARK: - IBOutlets -
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.showsCancelButton = true
            searchBar.placeholder = "Search news"
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: Cells.tableViewNib.rawValue, bundle: nil)
            let sourceNib = UINib(nibName: Cells.sourcesTableViewNib.rawValue, bundle: nil)
            tableView.register(sourceNib, forCellReuseIdentifier: Cells.sourcesTableViewIdentifier.rawValue)
            tableView.register(nib, forCellReuseIdentifier: Cells.tableViewIdentifier.rawValue)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 175
        }
    }
    //MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        addRefreshControl()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkSegmentedControl()
    }
    
    //MARK: - IBActions -
    
    @IBAction func segmentedTapped(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            print("11")
            navigationController?.setNavigationBarHidden(false, animated: true)
            searchBar.isHidden = false
            fetchData()
        case 1:
            searchBar.isHidden = true
            navigationController?.setNavigationBarHidden(true, animated: true)
            fetchSources()
        default:
            break
        }
        
    }
    
    
    @IBAction func buttonTapped(_ sender: UIBarButtonItem) {
        picker = UIPickerView.init()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .black
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    
    
    @IBAction func sortButtonTapped(_ sender: UIBarButtonItem) {
        if sortedBy {
            newsDataArray.sort(by: {$0.publishedAt ?? "" < $1.publishedAt ?? ""})
            sortedBy.toggle()
        } else {
            newsDataArray.sort(by: {$0.publishedAt ?? "" > $1.publishedAt ?? ""})
            sortedBy.toggle()
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Functions -
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        newsDataArray = []
        currentPage = 1
        fetchData()
    }
    
    func fetchData() {
        networkManager.fetchData(currentPage, currentCountry, currentCategory) { [weak self] (news) in
            guard let self = self else { return }
            self.newsData = news
            self.newsDataArray += news?.articles ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchNews(quary: String) {
        networkManager.searchNews(currentPage, quary) { [weak self] (news) in
            guard let self = self else { return }
            self.newsData = news
            self.newsDataArray += news?.articles ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchSources() {
        networkManager.fetchSources { [weak self] (sources) in
            guard let self = self else { return }
            self.sourcesData = sources?.sources ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func addRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        currentPage = 1
        searchNow = false
        newsDataArray.removeAll()
        fetchData()
        refreshControl.endRefreshing()
    }
    
    func checkSegmentedControl() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("11")
            navigationController?.setNavigationBarHidden(false, animated: true)
            searchBar.isHidden = false
            fetchData()
        case 1:
            searchBar.isHidden = true
            navigationController?.setNavigationBarHidden(true, animated: true)
            fetchSources()
        default:
            break
        }
    }
}

//MARK: - UITableView extension -
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return newsDataArray.count
        case 1:
            return sourcesData.count
        default:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.tableViewIdentifier.rawValue, for: indexPath) as! NewsTableViewCell
            
            cell.configure(newsDataArray[indexPath.row])
            
            if indexPath.row == newsDataArray.count - 1 && currentPage < newsData?.totalResults ?? 1{
                currentPage += 1
                if searchNow {
                    searchNews(quary: quary)
                } else {
                    fetchData()
                }
                
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.sourcesTableViewIdentifier.rawValue, for: indexPath) as! SourcesTableViewCell
            
            cell.configure(sourcesData[indexPath.row])
            
            return cell
        default:
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WebViewController()
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            vc.urlString = newsDataArray[indexPath.row].url
        case 1:
            vc.urlString = sourcesData[indexPath.row].url
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return 175
        case 1:
            return 90
        default:
            break
        }
        return 50
    }
}

//MARK: - UIPicker extension
extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return countryDataNames.count
        } else {
            return categoryDataNames.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return countryDataNames[row]
        } else {
            return categoryDataNames[row]
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.currentCountry = countryDataNames[row]
        } else {
            self.currentCategory = categoryDataNames[row]
        }
    }
}


extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let searchQuary = searchBar.text else { return }
        searchNow = true
        quary = searchQuary
        newsDataArray = []
        searchNews(quary: quary)
        tableView.reloadData()
        
        if searchBar.text?.isEmpty == true {
            quary = ""
            newsDataArray = []
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchNow = false
        newsDataArray = []
        tableView.reloadData()
        if searchBar.text?.isEmpty == true {
            view.endEditing(true)
        } else {
            searchBar.text? = ""
            view.endEditing(true)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == true {
            newsDataArray = []
            tableView.reloadData()
        }
        
        view.endEditing(true)
    }
    
}
