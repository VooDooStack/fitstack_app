import 'dart:developer';

import 'package:FitStack/main.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AnalyticsService extends NavigatorObserver {
  final bool debug;
  AnalyticsService({
    this.debug = false,
  });

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
  final FirebasePerformance performance = FirebasePerformance.instance;
  String currentRoute = "/";

  FirebaseAnalyticsObserver getAnalyticsObserver() => FirebaseAnalyticsObserver(analytics: analytics);

  Future setUserProperties({required String userId}) async {
    await analytics.setUserId(id: userId);
    await crashlytics.setUserIdentifier(userId);
  }

  Future<void> logEvent({required String name, Map<String, dynamic>? parameters}) async {
    if (debug) log("event logged: name: $name parameters: $parameters");

    await analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> logError({required String exception, StackTrace? stacktrace, required String reason, bool? fatal}) async {
    if (debug) {
      log("error logged: exception: $exception, stacktrace: $stacktrace, reason: $reason, fatal: $fatal");
    }

    await crashlytics.recordError(
      exception,
      stacktrace,
      reason: "$reason in $currentRoute",
      fatal: fatal ?? false,
      printDetails: kDebugMode,
    );
  }

  Future<Dio> networkPerformanceInterceptor({required Dio dio}) async {
    RequestOptions? dioOptions;
    HttpMetric? metric;

    if (!kDebugMode) {
      try {
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              dioOptions = options;
              metric = performance.newHttpMetric(
                options.path,
                HttpMethod.values.firstWhere(
                  (element) => element.name.toLowerCase() == dioOptions!.method.toLowerCase(),
                ),
              );
              metric!.start();
              handler.next(options);
            },
            onResponse: (response, handler) async {
              metric!
                ..responsePayloadSize = response.data.length
                ..responseContentType = response.headers.value('content-type')
                ..responsePayloadSize = response.data.length
                ..stop();
              if (debug) log("network performance logged: ${dioOptions?.path} with time");
              handler.next(response);
            },
            onError: (DioError e, handler) async {
              metric!
                ..responsePayloadSize = e.response?.data.length ?? 0
                ..responseContentType = e.response?.headers.value('content-type')
                ..responsePayloadSize = e.response?.data.length ?? 0
                ..stop();
              handler.next(e);
            },
          ),
        );
      } catch (e) {
        final error = e;
        if (debug) log("error adding dio wrapper");
        locator<AnalyticsService>().logError(exception: error.toString(), reason: 'error adding dio wrapper');
      }
    }

    return dio;
  }

  void get analyticsInstance => analytics;

  void get crashlyticsInstance => crashlytics;

  void get performanceInstance => performance;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (debug) log("observer constructed");
    currentRoute = route.settings.name ?? "/";
    analytics.setCurrentScreen(screenName: route.settings.name);
    if (debug) log('PUSHED SCREEN: ${route.settings.name}'); //name comes back null
  }
}
