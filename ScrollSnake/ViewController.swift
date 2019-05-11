//
//  ViewController.swift
//  ScrollSnake
//
//  Created by Zev Eisenberg on 9/13/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

import UIKit

class ThumbView: UIView {

    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }

    var scrollInfo: (position: CGFloat, thumbSize: CGFloat) = (0, 0.5) {
        didSet {
            let scrollRangeExcludingScrollThumb = 0...(1.0 - scrollInfo.thumbSize)
            let scrollPosition = scrollInfo.position.scaled(from: 0...1, to: scrollRangeExcludingScrollThumb)
            shapeLayer.strokeStart = scrollPosition
            shapeLayer.strokeEnd = scrollPosition + scrollInfo.thumbSize
        }
    }

    func animateAlphaToZero() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        }
    }

}

class ViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let thumbView = ThumbView()

    private let data = Array(repeating: ["snake", "pong", "breakout", "frogger"], count: 8).flatMap { $0 }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.showsVerticalScrollIndicator = false

        view.addSubview(tableView)
        view.addSubview(thumbView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        thumbView.translatesAutoresizingMaskIntoConstraints = false

        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        thumbView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        thumbView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        thumbView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        thumbView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        thumbView.isUserInteractionEnabled = false

        thumbView.shapeLayer.fillColor = nil
        thumbView.shapeLayer.strokeColor = UIColor.black.withAlphaComponent(0.4).cgColor
        thumbView.shapeLayer.lineWidth = 7.0 / 3.0 // 7 pixels in a 3x screenshot
        thumbView.shapeLayer.lineCap = .round
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        thumbView.alpha = 0
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let bounds = view.bounds
        let path = UIBezierPath()

        // Above the notch
        path.addArc(withCenter: CGPoint(x: bounds.width - 42, y: 42), radius: 38, startAngle: -.pi / 2, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: bounds.width - 4, y: 75))
        path.addArc(withCenter: CGPoint(x: bounds.width - 7, y: 77), radius: 3, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        path.addArc(withCenter: CGPoint(x: bounds.width - 11, y: 104), radius: 24, startAngle: -.pi / 2, endAngle: .pi, clockwise: false)

        // Long side of the notch
        path.addLine(to: CGPoint(x: bounds.width - 35, y: bounds.height - 104))

        // Below the notch
        path.addArc(withCenter: CGPoint(x: bounds.width - 11, y: bounds.height - 104), radius: 24, startAngle: .pi, endAngle: .pi / 2, clockwise: false)
        path.addArc(withCenter: CGPoint(x: bounds.width - 7, y: bounds.height - 77), radius: 3, startAngle: -.pi / 2, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: bounds.width - 4, y: bounds.height - 75))
        path.addArc(withCenter: CGPoint(x: bounds.width - 42, y: bounds.height - 42), radius: 38, startAngle: 0, endAngle: .pi / 2, clockwise: true)

        thumbView.shapeLayer.path = path.cgPath
    }

}

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }

}

extension ViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        thumbView.alpha = 1

        let contentOffset = scrollView.contentOffset.y
        let contentHeight = (scrollView.contentSize.height + view.safeAreaInsets.top + view.safeAreaInsets.bottom)
        let viewHeight = scrollView.frame.height

        let thumbSize = viewHeight / contentHeight

        let totalDistanceToScroll = contentHeight - viewHeight
        let fractionScrolled = contentOffset / totalDistanceToScroll

        thumbView.scrollInfo = (position: fractionScrolled, thumbSize: thumbSize)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        thumbView.animateAlphaToZero()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            thumbView.animateAlphaToZero()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

