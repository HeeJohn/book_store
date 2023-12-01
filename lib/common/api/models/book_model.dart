class BookModel {
  static const List<String> state = ['나쁨', '중간', '좋음'];
  final String bookName, bookPublisher, publishedYear;
  final int bookPrice, classID;
  final String? author, uploadTime;
  final BookState? bookState;
  final int? bookId, studentID, sumState;

  BookModel.fromJson(Map<String, dynamic> json)
      : bookName = json['book_name'],
        bookPublisher = json['publisher'],
        bookPrice = json['price'],
        publishedYear = json['published_year'],
        classID = json['class_id'],
        bookId = json['book_id'],
        author = json['author'],
        studentID = json['student_id'],
        uploadTime = json['upload_time'],
        bookState = BookState(
          hightlight: state[json['light'] - 1],
          ripped: state[json['ripped'] - 1],
          pencil: state[json['pencil'] - 1],
          pen: state[json['pen'] - 1],
          fade: state[json['fade'] - 1],
          dirty: state[json['dirty'] - 1],
        ),
        sumState = (json['light'] +
            json['pencil'] +
            json['pen'] +
            json['dirty'] +
            json['fade'] +
            json['ripped']);
}

class BookState {
  final String ripped, hightlight, pencil, pen, fade, dirty;

  BookState({
    required this.ripped,
    required this.hightlight,
    required this.pencil,
    required this.dirty,
    required this.fade,
    required this.pen,
  });
}
