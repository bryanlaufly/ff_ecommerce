Future<void> delay(bool addDelay,{int milliseconds = 2000}) async {
  if (addDelay) {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }
}
