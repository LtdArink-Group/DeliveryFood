import UIKit
import YandexMapKit


protocol SuggestAddressDelegate
{
    func addressDidChoose(_ controller: UIViewController, street: String, house: String)
}

struct SuggestAddressSettings {
    var centLat: Double!
    var centLon: Double!
    var radius: Double!
    var exclSubtitle: String!
}

class SuggestCell: UITableViewCell {
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var subTitle: UILabel!
}


class SuggestAddressController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    static func build (owner: UIViewController, initialValue: String?, onDidChoose: @escaping (_ street: String, _ house: String) -> Void) -> SuggestAddressController {
        let storyboardName = "SuggestAddress"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! SuggestAddressController
        controller.callbackOnDidChoose = onDidChoose
        controller.initialValue = initialValue
        controller._navParent = owner.navigationController!
        
        return controller
    }
    
    func present () {
        let navContr = UINavigationController(rootViewController: self)
        self._navParent.present(navContr, animated: true, completion: nil)
    }
    
    var delegate: SuggestAddressDelegate?
    var callbackOnDidChoose: ((_ street: String, _ house: String) -> Void)?
    var _navParent: UINavigationController!
    var initialValue: String?
    var doneButton: UIBarButtonItem!
    
    var settings: SuggestAddressSettings! = SuggestAddressSettings()
    
    var suggestResults: [YMKSuggestItem] = []
    let searchManager = YMKMapKit.sharedInstance().createSearchManager(with: .combined)
    
//    let BOUNDING_BOX = YMKBoundingBox(
//        southWest: YMKPoint(latitude: 48.33, longitude: 134.98),
//        northEast: YMKPoint(latitude: 48.61, longitude: 135.24))
    var BOUNDING_BOX: YMKBoundingBox!
    let SEARCH_OPTIONS = YMKSearchOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        cancelButton.tintColor = view.tintColor

        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        doneButton.tintColor = view.tintColor

        let topViewController = self.navigationController!.topViewController
        topViewController!.navigationItem.leftBarButtonItem = cancelButton;
        topViewController!.navigationItem.rightBarButtonItem = doneButton;

        searchBar.text = initialValue

        settings.centLat = settings.centLat ?? 48.483654
        settings.centLon = settings.centLon ?? 135.094723
        settings.radius = settings.radius ?? 15
        settings.exclSubtitle = settings.exclSubtitle ?? "Хабаровск, Россия"
        
        BOUNDING_BOX = YMKBoundingBox(
            southWest: YMKPoint(latitude: settings.centLat!-0.2, longitude: settings.centLon!-0.2),
            northEast: YMKPoint(latitude: settings.centLat!+0.2, longitude: settings.centLon!+0.2))
        
        tableView.dataSource = self
        tableView.delegate = self
        //SEARCH_OPTIONS.maxAdverts = 0
        //SEARCH_OPTIONS.searchClosed = true
        SEARCH_OPTIONS.geometry = true
        SEARCH_OPTIONS.suggestWords = true
        SEARCH_OPTIONS.resultPageSize = 100
        
        //SEARCH_OPTIONS.userPosition = YMKPoint(latitude: 48.4723342, longitude: 135.0432778)
        //SEARCH_OPTIONS.searchTypes = .geo
        
        checkDonButtonOnEnable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }

    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        sendResultToParentAndClose(addressTitle: searchBar.text, addressSubTitle: nil)
    }

    func onSuggestResponse(_ items: [YMKSuggestItem]) {
        suggestResults = items
            .filter({ (item) -> Bool in
                (item.distance == nil || item.distance!.value < settings.radius! * 1000)
                && (item.tags.count < 1 || item.tags[0] == "house" || (!isChoosenStreet() && item.tags[0] == "street"))
                //&& !isChoosenOnlyStreet()
        })
        tableView.reloadData()
    }
    

    func onSuggestError(_ error: Error) {
        let suggestError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if suggestError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if suggestError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func queryChanged(_ sender: UITextField) {
        let suggestHandler = {(response: [YMKSuggestItem]?, error: Error?) -> Void in
            if let items = response {
                self.onSuggestResponse(items)
            } else {
                self.onSuggestError(error!)
            }
        }
      
        checkDonButtonOnEnable()
        
        searchManager!.suggest(
            withText: sender.text!,
            window: BOUNDING_BOX,
            searchOptions: SEARCH_OPTIONS,
            responseHandler: suggestHandler)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt path: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestCell", for: path) as! SuggestCell
        cell.itemName.text = suggestResults[path.row].title.text
        
        let subTitle :String! = suggestResults[path.row].subtitle?.text ?? ""
        
        cell.subTitle.text = getOnlyTownIfOther(fromString: subTitle)

        return cell
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
  

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt path: IndexPath) {
        let suggest = suggestResults[path.row]

        debugPrint("dtext: ", suggestResults[path.row].displayText ?? "")
        debugPrint("subtitle: ", suggestResults[path.row].subtitle?.text ?? "")
        debugPrint("tag: ", suggestResults[path.row].tags[0])
        debugPrint("dist: ", suggestResults[path.row].distance?.text ?? "")
        

        if suggest.tags.count > 0 && suggest.tags[0] == "street" {
            self.searchBar.text = "\(suggest.title.text), "
            searchBar.keyboardType = .numbersAndPunctuation
            searchBar.reloadInputViews()
            suggestResults.removeAll()
            onSuggestResponse(suggestResults)
        }
        
        if suggest.tags.count > 0 && suggest.tags[0] == "house" {
            sendResultToParentAndClose(addressTitle: suggest.title.text, addressSubTitle: suggest.subtitle?.text)
            
        }
    }
    
    private func sendResultToParentAndClose(addressTitle: String?, addressSubTitle: String?) {
        var addr = getStreetAndHouseNumber(addressTitle: addressTitle)
        if addressSubTitle != nil && !addressSubTitle!.isEmpty {
            if let addressPrefix = getOnlyTownIfOther(fromString: addressSubTitle!) {
                addr.0 = "\(addressPrefix), \(addr.0)"
            }
        }
        delegate?.addressDidChoose(self, street: addr.0, house: addr.1)
        callbackOnDidChoose?(addr.0, addr.1)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /////----local helper----/////
    func isChoosenStreet() -> Bool {
        return self.searchBar.text != nil && searchBar.text!.range(of: ",") != nil
    }
    
//    private var applyFilterConstrainOnOnlyStreet = false
//    func isChoosenOnlyStreet() -> Bool {
//        let result = applyFilterConstrainOnOnlyStreet && self.searchBar.text != nil && searchBar.text!.trimmingCharacters(in:  .whitespacesAndNewlines).last == ","
//        applyFilterConstrainOnOnlyStreet = false
//        return result
//    }
    
    private func getOnlyTownIfOther(fromString: String) -> String? {
        var res: String?
        if fromString.range(of: settings.exclSubtitle) == nil {
            let commaOffset = fromString.index(of: ",")?.encodedOffset
            res = fromString.prefix(commaOffset ?? 0).description
        }
        return res
    }
    
    private func getStreetAndHouseNumber(suggest: YMKSuggestItem) -> (String, String) {
        var result = ("","")
        if suggest.tags.count > 0 && suggest.tags[0] == "house" {
            result = getStreetAndHouseNumber(addressTitle: suggest.title.text)
        }
        return result
    }
    
    private func getStreetAndHouseNumber(addressTitle: String?) -> (String, String) {
        var result = ("","")
        if addressTitle == nil {
            return result
        }
        let a = addressTitle!
        var i = a.range(of: ",", options: .backwards)?.lowerBound
        if i == nil {
            i = a.range(of: " ", options: .backwards)?.lowerBound
        }
        if (i != nil && i! < a.endIndex) {
            result.0 = String(a[..<i!])
            let i2 = a.index(a.startIndex, offsetBy: i!.encodedOffset+1)
            result.1 = String(a[i2...]).trimmingCharacters(in: .whitespacesAndNewlines)
            debugPrint("steet: ", result.0)
            debugPrint("house: ", result.1)
        }
        
        return result
    }
    
    func checkDonButtonOnEnable() {
        doneButton.isEnabled = searchBar.text != nil && !searchBar.text!.isEmpty  && (searchBar.text?.isValid(regExp: "^.{3,}[,\\ ]\\d+.*$"))!
    }
}
    

