import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petcare_flutter_pro/main.dart';
import 'package:petcare_flutter_pro/services/auth_service.dart';
import 'package:petcare_flutter_pro/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('PetCareApp smoke test renders login', (WidgetTester tester) async {
    // Provide a standard screen size
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final storage = StorageService();
    final auth = AuthService();

    await tester.pumpWidget(PetCareApp(
      storageService: storage,
      authService: auth,
      initialDarkMode: false,
    ));

    // Pump a few frames for animations
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify PetCare Pro title and login button are present
    expect(find.text('PetCare Pro'), findsOneWidget);
    expect(find.text('Sign In to Dashboard'), findsOneWidget);
    expect(find.text('Autofill Demo (admin / 1234)'), findsOneWidget);
  });
}
