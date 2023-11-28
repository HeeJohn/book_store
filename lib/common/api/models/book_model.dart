class BookModel {
  static const List<String> state = ['나쁨', '중간', '좋음'];
  final String bookName, bookPublisher, publishedYear;
  final int bookPrice;
  final String? author, uploadTime;
  final int classCode;
  final BookState? bookState;
  final int? bookId;
  final int? studentId;
  final int? sumState;
  BookModel({
    required this.bookPublisher,
    required this.publishedYear,
    required this.classCode,
    required this.bookPrice,
    this.bookState,
    required this.bookName,
    this.uploadTime,
    this.author,
    this.bookId,
    this.studentId,
  }) : sumState = 0;
  BookModel.fromJson(Map<String, dynamic> json)
      : bookName = json['book_name'],
        bookPublisher = json['publisher'],
        bookPrice = json['price'],
        publishedYear = json['published_year'],
        classCode = json['class_code'],
        bookId = json['book_id'],
        author = json['author'],
        studentId = json['student_id'],
        uploadTime = json['upload_time'],
        bookState = BookState(
          hightlight: state[json['light']],
          reaped: state[json['pencil']],
          pencil: state[json['pen']],
          pen: state[json['dirty']],
          fade: state[json['fade']],
          dirty: state[json['ripped']],
        ),
        sumState = json['light'] +
            json['pencil'] +
            json['pen'] +
            json['dirty'] +
            json['fade'] +
            json['ripped'];
}

class BookState {
  final String reaped, hightlight, pencil, pen, fade, dirty;

  BookState({
    required this.reaped,
    required this.hightlight,
    required this.pencil,
    required this.dirty,
    required this.fade,
    required this.pen,
  });
}
