String getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 11) {
    return "Selamat Pagi";
  } else if (hour < 15) {
    return "Selamat Siang";
  } else if (hour < 18) {
    return "Selamat Sore";
  } else {
    return "Selamat Malam";
  }
}