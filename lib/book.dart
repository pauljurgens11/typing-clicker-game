class Book {
  int _pagesWritten = 0;
  final int payForBook;

  Book({required this.payForBook});

  int getPagesWritten() {
    return _pagesWritten;
  }

  int getPayForBook() {
    return payForBook;
  }

  void setPagesWritten(int pagesWritten) {
    _pagesWritten = pagesWritten;
  }
}
