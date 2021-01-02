String firstWordFromParagraph(String paragraph) {
  if (paragraph.indexOf(" ") > -1) {
    return paragraph.replaceRange(paragraph.indexOf(" "), paragraph.length, "");
  } else {
    return paragraph;
  }
}

/// INPUT:  (A) Santiago Gallo Restrepo
/// OUTPUT: (A) Santiago
