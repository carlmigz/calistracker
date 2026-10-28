enum LibraryCategory {
  basics('Basics'),
  formTips('Form tips'),
  glossary('Glossary');

  const LibraryCategory(this.label);

  final String label;
}

class LibraryEntry {
  const LibraryEntry({
    required this.title,
    required this.category,
    required this.body,
  });

  final String title;
  final LibraryCategory category;
  final String body;
}
