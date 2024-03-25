import Foundation

struct FilterViewModel {
    let prefectures = Prefectures().prefectures
    let loadFileDataModel = LoadFileDataModel()

    /// hobbyを取得
    func fetchHobbyData() -> [String] {
        guard let hobbys = loadFileDataModel.loadCsvFile(fileName: "HobbyList") else {
            return []
        }

        return hobbys
    }
}
