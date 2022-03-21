//
//  TableViewController.swift
//  Artwork
//
//  Created by Arwa Alfuraih on 23/02/2022.
//

import UIKit
import PassKit

class ArtworkShopController: UITableViewController , PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment , handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        print("Success Authorized payment ")
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))

    }
   // var imageUrl : URL?
    
    struct artPiece {
        var pieceName: String
        var price: Double
    }
    
    @IBOutlet weak var contract: UIButton!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var priceShape: UIView!
    @IBOutlet weak var archiveShape: UIView!
    @IBOutlet weak var creditShape: UIView!
    @IBOutlet weak var alanoud: UIImageView!
    @IBOutlet weak var after: UIView!
    @IBOutlet weak var before: UIView!
    @IBOutlet weak var zendaya: UIImageView!
    @IBOutlet weak var pay: UIButton!
    @IBOutlet weak var payShape: UIView!
    @IBOutlet weak var progress: UILabel!
    @IBOutlet weak var finalized: UILabel!
    @IBOutlet weak var afterLabel: UILabel!
    @IBOutlet weak var beforeLabel: UILabel!
    @IBOutlet weak var alanoudName: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var visa: UILabel!
    @IBOutlet weak var zendayaLabel: UILabel!
    
    //   @IBOutlet weak var description: UITextView!
    
    
    
    //----Payment Props----//
    private var paymentRequest : PKPaymentRequest = {
        
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.Artwork"
        request.supportedNetworks = [.quicPay, .masterCard, .visa]
        request.supportedCountries = ["SA","US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "SA"
        request.currencyCode = "SAR"
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Fox Spirit Artwork", amount: 2000)]
        
        return request
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
     
      
        //------Translation-------//
         
         alanoudName.text = NSLocalizedString("Alanoud", comment: "")
        progress.text = NSLocalizedString("Artwork Progress", comment: "")
        finalized.text = NSLocalizedString("Finalized Masterpiece", comment: "")
         beforeLabel.text = NSLocalizedString("Before", comment: "")
         afterLabel.text = NSLocalizedString("After", comment: "")
         zendayaLabel.text = NSLocalizedString("Zendaya", comment: "")
        desc.text = NSLocalizedString("The Process of inspiration and brining the sketch into life to represent the fox spirit was such a fun expierence !", comment: "")
         visa.text = NSLocalizedString("Pay with credit card", comment:"")
        contract.setTitle(NSLocalizedString("Contract Agreement", comment: ""), for: .normal)

        
    //----Styling -----//
        
    before.layer.cornerRadius = 10
    after.layer.cornerRadius = 10
    image1.layer.borderWidth = 1
    image1.layer.cornerRadius = 22
    image2.layer.borderWidth = 1
    image2.layer.cornerRadius = 22
    archiveShape.layer.cornerRadius = 15
    priceShape.layer.cornerRadius = 15
    creditShape.layer.cornerRadius = 6
    payShape.layer.cornerRadius = 6
        pay.titleLabel?.font =  UIFont( name: "GillSans-Italic", size: 30)
    self.pay.addTarget(self, action: #selector(payment), for: .touchUpInside)
   
    }

    @objc func payment () {

        
        
        print("Payment function")

        let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        if controller != nil {
            controller!.delegate = self
            
            present(controller!, animated:true){
                [self] in
              
                
                
                guard let url = URL (string: "https://s30.aconvert.com/convert/p3r68-cdx67/apqjq-d4i0a.pdf")
                else {
                    return
                }
                let urlSession = URLSession(configuration: .default , delegate: self , delegateQueue: OperationQueue())
                let downloadTask = urlSession.downloadTask(with: url)
                downloadTask.resume()
                self.downloadAlert()
                print("Completed Payment")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 10){
                    self.downloadAlert()
                }
                

        }
       
        }
        
    }
    
    @IBAction func contract(_ sender: Any) {
        
        let secondVC = storyboard?.instantiateViewController(withIdentifier: "secondVC") as! SecondViewController
        
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
  
    func downloadAlert(){
        print("in alert")
        let alert = UIAlertController (title: "Success!!" , message: "You've downloaded the Art Piece File Successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismess", style: .cancel))
        present(alert , animated: true)
        
     //   alert.title = NSLocalizedString(<#T##key: String##String#>, comment: "")
     //   alert.message = NSLocalizedString(<#T##key: String##String#>, comment: "")
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 0
    }

}//end of table View Controller


extension ArtworkShopController : URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url
        else {
            return
        }

        let docsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask) [0]
        let destinationPath = docsPath.appendingPathComponent(url.lastPathComponent)

        try? FileManager.default.removeItem(at: destinationPath)

        do {
            try FileManager.default.copyItem(at: location, to: destinationPath)
        //    self.imageURL = destinationPath;
        } catch let error {
            print ("Copy Error: \(error.localizedDescription)")

        }
    }
    
}

