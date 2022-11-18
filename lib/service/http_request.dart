import 'package:dio/dio.dart';

class HttpRequest {
  static final BaseOptions baseOptions = BaseOptions(
      connectTimeout: 5000
  );
  static final Dio _dio = Dio(baseOptions);

  // 全局拦截器
  // 创建默认的全局拦截器
  static Interceptor _dInter = InterceptorsWrapper(
     onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
       handler.next(options);
     },
    onResponse: (Response e, ResponseInterceptorHandler handler) {
       handler.next(e);
    },
    onError: (DioError e, ErrorInterceptorHandler handler) {
       handler.next(e);
    }
  );
  static Future<T> request<T>(String url, {
    String method = "get",
    Map<String, dynamic>? params,
    dynamic data,
    Interceptor? inter}) async {
    // 1.创建单独配置
    final options = Options(method: method);

    List<Interceptor> inters = [_dInter];
    // 请求单独拦截器
    if (inter != null) {
      inters.add(inter);
    }
    // 统一添加到拦截器中
    _dio.interceptors.addAll(inters);
    // 2.发送网络请求
    try {
      Response response = await _dio.request(url, queryParameters: params, data: data, options: options);
      return response.data;
    } on DioError catch(e) {
      return Future.error(e);
    }
  }

  static Future<T> get<T>(String url,
      {
        Map<String, dynamic>? params,
        Interceptor? inter
      }) {
    return request(url, method: 'get', params: params, inter: inter);
  }


  static Future<T> post<T>(String url,
      {
        Map<String, dynamic>? params,
        Interceptor? inter
      }) {
    return request(url, method: 'post', data: params, inter: inter);
  }
}