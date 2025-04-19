class BaseUrls {
  BaseUrls._();

  static String token = 'token';
  // آدرس‌های مختلف برای محیط‌های مختلف
  static const bool isProduction = false; // تنظیم به false برای محیط توسعه و true برای محیط تولید
  
  // آدرس پیش‌فرض بر اساس محیط
  static String get baseUrl {
    if (isProduction) {
      return 'https://asoud.ir/api/v1/';
    } else {
      // آدرس IP برای محیط توسعه
      return 'http://10.0.2.2:8000/api/v1/'; // برای اجرا در شبیه‌ساز اندروید
      // return 'http://localhost:8000/api/v1/'; // برای اجرا در وب یا دسکتاپ
      // return 'http://5.34.201.94/api/v1/'; // آدرس فعلی سرور
    }
  }
}
