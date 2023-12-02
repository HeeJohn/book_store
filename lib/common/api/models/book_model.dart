class BookModel {
  final String bookName, bookPublisher, publishedYear;
  final int bookPrice, classID;
  final String? author, uploadTime;
  final int? bookId, studentID;

  BookModel.fromJson(Map<String, dynamic> json)
      : bookName = json['book_name'],
        bookPublisher = json['publisher'],
        bookPrice = json['price'],
        publishedYear = json['published_year'],
        classID = json['class_id'],
        bookId = json['book_id'],
        author = json['author'],
        studentID = json['student_id'],
        uploadTime = json['upload_time'];
}

class BookState {
  static const List<String> state = ['나쁨', '중간', '좋음'];
  final int ripped, hightlight, pencil, pen, fade, dirty;
  int getSum() {
    return ripped + hightlight + pencil + pen + fade + dirty;
  }

  String getState(int what) {
    return state[what - 1];
  }

  BookState.fromJson(Map<String, dynamic> json)
      : ripped = json['ripped'],
        hightlight = json['light'],
        pencil = json['pencil'],
        pen = json['pen'],
        fade = json['fade'],
        dirty = json['dirty'];
}
