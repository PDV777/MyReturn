//КЛАСС для управления контроллером таблицы
import UIKit

final class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}//Создаём массив чисел от 0 до 19 и возвращаем массив строк, который мы и записываем в константу photosName.

    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self //передаю делегат контроллеру
        tableView.dataSource = self //  сообщаю таблице, какой объект будет источником данных.
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0) // задаем отступ таблице
    }
    
    //код для сегвея дающий путь перехода от таблицы imageListContr картинок в 1му изображению в singleImage
    override func prepare(for segue: UIStoryboardSegue,sender:Any?) {
        if segue.identifier == showSingleImageSegueIdentifier { //1
//            Сначала мы проверяем идентификатор сегвея, чтобы точно определить, куда собираемся сделать переход. Проверка нужна, потому что вы можете добавить больше одного сегвея, которые выходят из контроллера.
           guard
            let viewController = segue.destination as? SingleImageViewController,//2
//            Преобразуем тип для свойства segue.destination (у него тип UIViewController) к тому, который мы ожидаем (выставлен в Storyboard). В нашем случае — переходим от таблицы с изображениями к SingleImageViewController. Используем guard для безопасного приведения segue.destination к SingleImageViewController, чтобы избежать сбоев при неверно указанном типе в Storyboard.
            let indexPath = sender as? IndexPath//3
//                Преобразуем тип для аргумента sender (ожидаем, что там будет indexPath). Мы не сможем сконфигурировать переход верно, если там окажется что-то другое.
            else {
               assertionFailure("Invalid segue destination")//4
//               Если окажется, что мы выбрали неправильный сегвей или не настроили его нужным образом, выполним assertionFailure. Так приложение упадёт в режиме отладки с понятным сообщением и вы сможете устранить проблему, при этом приложение не будет крэшиться у пользователей, хоть и не выполнит переход.
               return
           }
            let image = UIImage(named: photosName[indexPath.row])//5
//            Получаем по индексу название картинки и саму картинку из ресурсов приложения.
            viewController.image = image//6
//            Передаём эту картинку в imageView внутри SingleImageViewController.
        } else {
            super.prepare(for: segue, sender: sender)//7
//            Если это неизвестный сегвей, есть вероятность, что он был определён суперклассом (то есть родительским классом). В таком случае мы должны передать ему управление.
        }
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
        performSegue(withIdentifier:showSingleImageSegueIdentifier, sender: indexPath)
    }
    //метод для установки размера ячейки в зависимости размера изображения
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard
            let image = UIImage(named: photosName[indexPath.row]) else {
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

