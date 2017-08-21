//
//  ScanController.swift
//  SwiftWB
//
//  Created by huangjinbiao on 17/2/14.
//  Copyright © 2017年 huangjinbiao. All rights reserved.
//

import UIKit
import AVFoundation

class ScanController: UIViewController {
    @IBOutlet weak var scanLineTopCon: NSLayoutConstraint!
    
    @IBOutlet weak var scanContainer: UIView!
    //输入
    lazy var input: AVCaptureInput? = {
        let tempDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device:tempDevice)
    }()
    //会话
    lazy var session : AVCaptureSession = AVCaptureSession()
    //输出
    lazy var output : AVCaptureMetadataOutput = {
        let out = AVCaptureMetadataOutput()
        // 设置输出对象解析数据时感兴趣的范围
        // 默认值是 CGRect(x: 0, y: 0, width: 1, height: 1)
        // 通过对这个值的观察, 我们发现传入的是比例
        // 注意: 参照是以横屏的左上角作为, 而不是以竖屏
        //        out.rectOfInterest = CGRect(x: 0, y: 0, width: 0.5, height: 0.5)
        
        // 1.获取屏幕的frame
        let viewRect = self.view.frame
        // 2.获取扫描容器的frame
        let containerRect = self.scanContainer.frame
        let x = containerRect.origin.y / viewRect.height;
        let y = containerRect.origin.x / viewRect.width;
        let width = containerRect.height / viewRect.height;
        let height = containerRect.width / viewRect.width;
        
        out.rectOfInterest = CGRect(x: x, y: y, width: width, height: height)
        
        return out
    }()
    //预览图层
    lazy var previewLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    //容器图层
    lazy var containerLayer : CALayer = CALayer()

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        scanQRCode()
    }
    
    func scanQRCode() -> () {
        //判断输入能否添加到会话中
        if !session.canAddInput(input){
            return
        }
        //判断输出能否添加到会话中
        if !session.canAddOutput(output) {
            return
        }
        //添加输入和输出到会话中
        session.addInput(input)
        session.addOutput(output)
        //设置输出的解析类型
        //要先把output添加到会话中才能设置解析类型
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        //设置监听输出解析到的数据
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = view.bounds
        //添加容器图层
        view.layer.addSublayer(containerLayer)
        containerLayer.frame = view.bounds
        //开始扫描
        session.startRunning()
    }
    
    func startAnimation() -> () {
        weak var weakSelf = self
        UIView.animate(withDuration: 2, animations: {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            weakSelf?.scanLineTopCon.constant = 200
            weakSelf?.view.layoutIfNeeded()
        }) { (flag) in
            if flag == true{
                
            }
        }
    }
    
    @IBAction func itemClick(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 0:
            navigationController?.popViewController(animated: true)
        default:
            popImagePicker()
        }
    }
    
    func popImagePicker() -> () {

        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}
extension ScanController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        // 1.取出选中的图片
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else
        {
            return
        }
        
        guard let ciImage = CIImage(image: image) else
        {
            return
        }
        
        // 2.从选中的图片中读取二维码数据
        // 2.1创建一个探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        // 2.2利用探测器探测数据
        let results = detector?.features(in: ciImage)
        // 2.3取出探测到的数据
        for result in results!
        {
            MYLOG(message: (result as! CIQRCodeFeature).messageString)
        }
    }
}
extension ScanController: AVCaptureMetadataOutputObjectsDelegate{
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // 2.拿到扫描到的数据
        clearLayers()
        guard let metadata = metadataObjects.last as? AVMetadataObject else
        {
            return
        }
        // 通过预览图层将corners值转换为我们能识别的类型
        let objc = previewLayer.transformedMetadataObject(for: metadata)
        guard let readableObj = objc as? AVMetadataMachineReadableCodeObject else {
            return
        }
        drawLines(objc: readableObj)
    }
    
    /// 绘制描边
    private func drawLines(objc: AVMetadataMachineReadableCodeObject)
    {
        
        // 0.安全校验
        guard let array = objc.corners else
        {
            return
        }
        
        // 1.创建图层, 用于保存绘制的矩形
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = UIColor.green.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        // 2.创建UIBezierPath, 绘制矩形
        let path = UIBezierPath()
        var point = CGPoint.zero
        var index = 0
        point = CGPoint(dictionaryRepresentation: (array[index] as! CFDictionary))!
        index += 1
        
        // 2.1将起点移动到某一个点
        path.move(to: point)
        
        // 2.2连接其它线段
        while index < array.count
        {
            point = CGPoint(dictionaryRepresentation: (array[index] as! CFDictionary))!
            index += 1
            path.addLine(to: point)
        }
        // 2.3关闭路径
        path.close()
        
        layer.path = path.cgPath
        // 3.将用于保存矩形的图层添加到界面上
        containerLayer.addSublayer(layer)
    }
    /// 清空描边
    private func clearLayers()
    {
        guard let subLayers = containerLayer.sublayers else
        {
            return
        }
        for layer in subLayers
        {
            layer.removeFromSuperlayer()
        }
    }
}
