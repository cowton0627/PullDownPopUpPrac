//
//  ViewController.swift
//  PullDownPopUpPrac
//
//  Created by Chun-Li Cheng on 2022/7/1.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    // 設定 image 呈現原來的形式
    private let image = UIImage(named: "redPackage")?.withRenderingMode(.alwaysOriginal)
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let buttonWidth: CGFloat = 88
    private let buttonHeight: CGFloat = 44
    private var buttonCenterX: CGFloat { screenWidth/2 - buttonWidth/2 }
    private var buttonCenterY: CGFloat { screenHeight/2 - buttonHeight/2 }
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        
        button.frame = CGRect(x: buttonCenterX,
                              y: buttonCenterY,
                              width: buttonWidth,
                              height: buttonHeight)

        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 10
        button.setTitle("Item", for: .normal)
        // show popover
        button.showsMenuAsPrimaryAction = true
        // 原 title 或 image 會跟著 popover 選擇變動，也因此才有打勾紀錄
        button.changesSelectionAsPrimaryAction = true

        return button
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLeftBar()
        configureCenterButton()
//        configureSelectorForLeftOrRightBar()
        
        // MARK: - Autoresizing 必搭配 Constraint.activate，而不與 UIElement.frame = CGRect 一起用。
//        button.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
    }
    
    // MARK: - Private Functions
    private func configureLeftBar() {
        // 第一階層的 menu
        let menu = UIMenu(
            title: "First Chioce",
            children: [
                UIAction(title: "天干") { act in
                    print("Select 天干")
                },
                UIAction(title: "地支") { act in
                    print("Select 地支")
                },
                UIAction(title: "生年") { act in
                    print("Select 生年")
                },
                UIAction(title: "大運") { act in
                    print("Select 大運")
                },
                UIAction(title: "Pins",
                         image: UIImage(systemName: "pin")) { act in
                    print("Select Pins")
                },
                // state 設為 on，且 changesSelectionAsPrimaryAction 為 true，預設為此項
                UIAction(title: "Checkmark",
                         image: UIImage(systemName: "checkmark.circle"),
                         state: .on) { act in
                    print("Select Checkmark")
                },
                
                // 自選圖選後，顯示圖片跑到 NavBar 中央
//                UIAction(title: "發紅包了",
//                         image: image) { act in
//                    print("Red Envelope is coming")
//                },
                
                /*
                 *  第二階層的 menu，在 .singleSelection 與 .destructive 才會有階層縮放
                 *  .destructive title 與 image 會變成紅字
                 */
                UIMenu(title: "Second Choice",
                       subtitle: "sc",
                       image: UIImage(systemName: "circle"),
                       options: .destructive,
                       children: [
                        UIAction(title: "Avatar",
                                 image: UIImage(systemName: "person.crop.circle")) { act in
                            print("Select Avatar")
                        },
                        UIAction(title: "Manual",
                                 image: UIImage(systemName: "menucard")) { act in
                            print("Select Manual")
                        },
                        UIAction(title: "Up Down",
                                 image: UIImage(systemName: "arrow.up.arrow.down")) { act in
                            print("Select up and down")
                        }
                ])
        ])
        
        // 設定 leftBarButtonItem 彈出提示框為 menu
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "",
                                                                image: UIImage(systemName: "plus"),
                                                                menu: menu)
        // 原 title 或 image 會跟著 popover 選擇變動，也因此才有打勾紀錄
        self.navigationItem.leftBarButtonItem?.changesSelectionAsPrimaryAction = true

    }
    
    private func configureCenterButton() {
        view.addSubview(button)

        let menu = UIMenu(
            title: "",
            image: nil,
            identifier: nil,
            options: [.singleSelection, .displayInline],
            children: [
                    // Add your menu children here
                    UIAction(title: "Action 1", handler: { _ in
                        // Handle action 1
                    }),
                    UIAction(title: "Action 2", handler: { _ in
                        // Handle action 2
                    }),
                    UIAction(title: "Action 3", handler: { _ in
                        // Handle action 3
                    }),
                    UIAction(title: "Action 4", handler: { _ in
                        // Handle action 4
                    }),
                ]
        )
        print(menu)
        
        // 設定中央 button 的 popover
        button.menu = menu
    }
    
    private func configureSelectorForLeftOrRightBar() {
        // MARK: - 以 selector 加入 button action 的例子
        self.navigationItem.leftBarButtonItem =
        UIBarButtonItem(image: UIImage(systemName: "triangle"),
                        style: .plain,
                        target: self,
                        action: #selector(buttonTapped))
        
//        self.navigationItem.rightBarButtonItem =
//        UIBarButtonItem(image: UIImage(systemName: "plus"),
//                        style: .plain,
//                        target: self,
//                        action: #selector(buttonTapped))
    }
    
    
    // MARK: - IBAction
    @IBAction func rightBarButtonItemTapped(_ sender: UIBarButtonItem) {
        // Storyboard 生成的 popover 顏值稍低
//        guard let vc = storyboard?.instantiateViewController(withIdentifier: "\(PopoverPresentationTableViewController.self)") else { return }
        
        let vc = PopoverPresentationTableViewController()
        // 設定為提示框形式
        vc.modalPresentationStyle = .popover
        // 指定提示框的彈出位置為 rightBarButtonItem
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        // 設定 delegate
        vc.popoverPresentationController?.delegate = self
        // 設定 popover content size
        vc.preferredContentSize = CGSize(width: 200, height: 177)
        
//        vc.popoverPresentationController?.sourceRect = CGRect(x: button.frame.maxX, y: button.frame.maxY, width: 50, height: 50)
//        vc.popoverPresentationController?.sourceView = view
        
        present(vc, animated: true, completion: nil)
    }
    
    // 保證 popover 的 presentationStyle 不因環境而變
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: - objc functions
    @objc private func buttonTapped() {
        // 由 Storyboard 生成的 popover 顏值稍低
//        guard let vc  = storyboard?.instantiateViewController(withIdentifier: "\(PopoverPresentationTableViewController.self)") else { return }
        
        let vc = PopoverPresentationTableViewController()
        // 設定為提示框形式
        vc.modalPresentationStyle = .popover
        // 指定提示框的彈出位置為 leftBarButtonItem
        vc.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        // 設定 delegate
        vc.popoverPresentationController?.delegate = self
        // 設定 popover content size
        vc.preferredContentSize = CGSize(width: 200, height: 177)
        
//        vc.popoverPresentationController?.sourceRect = CGRect(x: button.frame.maxX, y: button.frame.maxY, width: 50, height: 50)
//        vc.popoverPresentationController?.sourceView = view

        present(vc, animated: true, completion: nil)

    }
    
}

// MARK: - UIPopoverPresentationControllerDelegate
extension ViewController: UIPopoverPresentationControllerDelegate {

}

