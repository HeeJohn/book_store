class RegisteredBookModel {
  final String bookName, bookOwner, bookPublisher, bookPublishedDate, classCode;
  final String bookPrice;
  final BookState bookState;

  RegisteredBookModel.fromJson(Map<String, dynamic> json)
      : bookName = json['booK_name'],
        bookOwner = json['book_owner'],
        bookPublisher = json['book_publisher'],
        bookPrice = json['book_price'],
        bookPublishedDate = json['book_published_date'],
        classCode = json['class_code'],
        bookState = BookState(
          stateNum: json['book_state'],
        );
}

class BookState {
  static const List<String> state = ['좋음', '중간', '나쁨'];
  final String reaped, hightlight, pencil, pen, fade, dirty;
  final List<int> stateNum;
  BookState({
    required this.stateNum,
  })  : dirty = state[stateNum[0]],
        reaped = state[stateNum[0]],
        hightlight = state[stateNum[0]],
        pencil = state[stateNum[0]],
        pen = state[stateNum[0]],
        fade = state[stateNum[0]];
}
