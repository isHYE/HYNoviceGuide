//
//  ViewController.swift
//  NoviceGuideDemo
//
//  Created by 黄益 on 2021/1/4.
//

import UIKit

class ViewController: UIViewController {
    
    private let guideArray = ["圆形引导", "矩形引导"]
    
    private var tableView = { () -> UITableView in
        let tableView = UITableView(frame: CGRect(x: 0, y: 100, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 200), style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    /// 确认
    private lazy var noviceGuideConfirmLab = { () -> UILabel in
        let lab = UILabel()
        lab.text = "知道了"
        lab.textColor = .white
        lab.textAlignment = .center
        lab.font = UIFont.systemFont(ofSize:  16)
        lab.layer.cornerRadius = 4
        lab.layer.masksToBounds = true
        lab.layer.borderColor = UIColor.white.cgColor
        lab.layer.borderWidth = 1
        lab.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return lab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
        
    }
    
    private func createUI() {
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    @objc private func confrimBtnPressed() {
        print("确认")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guideArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = guideArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0: // 圆形引导
            if let cell = tableView.cellForRow(at: indexPath) {
                let guide = HYNoviceGuideManager([.circular(CircularGuideConfigModel(hollowView: cell))])
                guide.startGuide()
            }
            break
            
        case 1: // 矩形引导
            
            if let cell = tableView.cellForRow(at: indexPath) {
                let guide = HYNoviceGuideManager(
                    [
                        .rectangle(RectangleGuideConfigModel(cornerRadius: 15,
                                                              hollowFrame: CGRect(x: 100, y: 100, width: 150, height: 30),
                                                              guideArray: [(view: noviceGuideConfirmLab,
                                                                            size: CGSize(width: 200, height: 50),
                                                                            location: .bottom())])),
                        
                        .rectangle(RectangleGuideConfigModel(cornerRadius: 5,
                                                             hollowView: cell,
                                                             guideArray: [(view: UIImageView(image: UIImage(named: "guide_img")),
                                                                           size: CGSize(width: 300, height: 50),
                                                                           location: .bottom(UIOffset(horizontal: -10, vertical: 0))),
                                                                          (view: noviceGuideConfirmLab,
                                                                           size: CGSize(width: 100, height: 50),
                                                                           location: .bottom())]))
                    ])
                guide.startGuide()
            }
            break
            
        default:
            break
        }
    }
}
