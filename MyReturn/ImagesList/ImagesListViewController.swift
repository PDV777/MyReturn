//КЛАСС для управления контроллером таблицы
import UIKit

final class ImagesListViewController: UIViewController {
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}

    @IBOutlet private var tableView: UITableView! //Создаём массив чисел от 0 до 19 и возвращаем массив строк, который мы и записываем в константу photosName.
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self //передаю делегат контроллеру
        tableView.dataSource = self //  сообщаю таблице, какой объект будет источником данных.
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0) // задаем отступ таблице
        
    }
    
    func configCell(for cell: ImagesListCell,with indexPath:IndexPath) {
        
    }
}
//отдельное расширение под протокол делегата
extension ImagesListViewController:UITableViewDelegate {
    //Этот метод отвечает за действия, которые будут выполнены при тапе по ячейке таблицы.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //пока пусто
    }
}
//отдельное расширение под протокол dataSourse
extension ImagesListViewController:UITableViewDataSource {
    // 1 обязательные метод для таблицы который определяет количество ячеек в секции таблицы, возврат значения.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // 2 обязательные метод для таблицы должен возвращать ячейку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIndifier)
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

