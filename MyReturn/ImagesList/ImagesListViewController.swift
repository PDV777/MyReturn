//КЛАСС для управления контроллером таблицы
import UIKit

final class ImagesListViewController: UIViewController {
    
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}//Создаём массив чисел от 0 до 19 и возвращаем массив строк, который мы и записываем в константу photosName.

    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self //передаю делегат контроллеру
        tableView.dataSource = self //  сообщаю таблице, какой объект будет источником данных.
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0) // задаем отступ таблице
        
    }
    }
//отдельное расширение под протокол dataSourse
extension ImagesListViewController:UITableViewDataSource {
    // 1 обязательные метод для таблицы который определяет количество ячеек в секции таблицы, возврат значения.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count // возвращаем сумму массива photosName
    }
    // 2 обязательные метод для таблицы должен возвращать ячейку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIndifier,for: indexPath)
        //        tableView.dequeueReusableCell(withIdentifier:) извлекает ячейку из пула переиспользуемых ячеек (если такая есть).
        //        Если такой ячейки нет в очереди переиспользования, создаётся новая.
        //        ImagesListCell.reuseIndifier – идентификатор, который должен совпадать с тем, что задан в Storyboard или зарегистрирован программно.
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
            //        cell имеет тип UITableViewCell?, но нам нужна конкретная кастомная ячейка ImagesListCell.
            //        as? пытается привести cell к ImagesListCell.
            //        Если приведение не удалось (cell == nil или не ImagesListCell), возвращается пустая UITableViewCell() (это защита от ошибок).
        }
            configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}
//метод для конфгурации ячеек
extension ImagesListViewController {
    func configCell(for cell: ImagesListCell,with indexPath:IndexPath) {
        
        cell.dateLabel.text = dateFormatter.string(from: Date()) // вызов DateFormater
        
        guard let image = UIImage(named: photosName[indexPath.row]) else { // извлечние картинок
            return
        }
        
        cell.cellImage.image = image
        
        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "LikeButtonOn") : UIImage(named: "LikeButtonOff")
        cell.likeButton.setImage(likeImage, for: .normal)
        
        }
}

//отдельное расширение под протокол делегата
extension ImagesListViewController:UITableViewDelegate {
    //Этот метод отвечает за действия, которые будут выполнены при тапе по ячейке таблицы.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { 
        tableView.deselectRow(at: indexPath, animated: true) // отключает выделенный тап,добавил сам,может и не понадобится
    }
    //метод для установки размера ячейки в зависимости размера изображения
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

