import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final String serverUrl = 'http://15.164.151.155:8080';

  Future<void> _login() async {
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/login'),
        body: {
          'id': idController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        // 로그인 성공
        print('로그인 성공!');

        // 토큰 저장
        String token = response.body;

        // 로그인 후 다음 페이지로 이동
        Navigator.pushNamed(context, '/home');
      } else {
        // 로그인 실패
        print('로그인 실패. 서버 응답 코드: ${response.statusCode}');
        print('응답 본문: ${response.body}');
      }
    } catch (error) {
      // 예외 처리
      print('로그인 중 오류: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: '아이디'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                // 로그인 함수 호출
                _login();
              },
              child: Text('로그인'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 회원가입 페이지로 이동
                Navigator.pushNamed(context, '/register');
              },
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}


