import UIKit

final class FAQSection: Section<FAQCellModel> { }

extension FAQSection {

    static func makeSection() -> [FAQSection] {

        return [
            .init(title: "",
                  items: [FAQCellModel(title: perevod("How to connect to Printer"),
                                       texts: [perevod("Make sure your printer is powered on and in range of your Wi-Fi network"),
                                               perevod("Use the printer’s control panel to connect it to your Wi-Fi network. Ensure the printer is within range of the wireless router for successful communication"),
                                               perevod("Select “Add a printer” and choose your wireless printer from the list")]),
                          FAQCellModel(title: perevod("Unable to find your printer"),
                                       texts: [perevod("Check that your printer is turned on and has no error indicators. Restart it to refresh the connection."),
                                               perevod("Make sure your iPhone or iPad and the printer are connected to the same Wi-Fi network."),
                                               perevod("Ensure the printer isn’t out of paper, ink, or toner."),
                                               perevod("Look for any alerts on the printer screen and refer to the user manual to troubleshoot them."),
                                               perevod("Visit your printer manufacturer’s website to see if a firmware update is available — even new printers may require one."),
                                               perevod("Lastly, confirm that your printer actually supports AirPrint — not all printers do.")]),
                          FAQCellModel(title: perevod("Which printing devices are supported"),
                                               texts: [perevod("We support over 7,000 popular printer models from leading brands, including: HP, Canon, Epson, Brother, Polono, Aurora, Dell, Develop, Fuji, Gestetner, Infotec, Konica, Lanier, Lexmark, MI, NRG, OKI, Olivetti, Panasonic, Pantum, Ricoh, Samsung, Savin, Sharp, Sindoh, TA, Toshiba, Xerox, ZINK, and more. Supported printer models:")],
                                       link: "https://support.apple.com/en-us/HT201311"),
                          FAQCellModel(title: perevod("What document formats are currently available for printing"),
                                               texts: [perevod("There are currently seven supported formats: doc, docx, xls, xIsx, ppt, pptx, pdf.")])
                  ])]
    }
}

