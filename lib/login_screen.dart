import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'register_screen.dart';
import 'dart:convert';

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
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': idController.text,
          'pw': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // 응답 본문에서 공백 제거 후 비교
        if (response.body.toString().trim() == "로그인 성공") {
          // 로그인 성공
          print('로그인 성공!');
          print('로그인 성공. 서버 응답 코드: ${response.statusCode}');
          // 토큰 저장
          String token = response.body;

          // 로그인 후 다음 페이지로 이동
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // 로그인 실패
          print('로그인 실패. 서버 응답 코드: ${response.statusCode}');
          print('응답 본문: ${response.body}');

          // 실패 메시지를 사용자에게 알림
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('로그인 실패. 다시 시도해주세요.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // 다른 상태 코드에 대한 처리 (필요한 경우)
        print('서버 응답 코드: ${response.statusCode}');
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



