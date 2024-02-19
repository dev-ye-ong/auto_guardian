import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final String serverUrl = 'http://15.164.151.155:8080';

  Future<void> _register() async {
    try {
      // Step 1: 서버로 이메일 및 전화번호 인증 요청
      final emailResponse = await http.post(
        Uri.parse('$serverUrl/signup/checkemail'),
        body: {'email': emailController.text},
      );

      final phoneResponse = await http.post(
        Uri.parse('$serverUrl/signup/checkphone'),
        body: {'phone': phoneController.text},
      );

      // 이메일 및 전화번호 인증이 성공하면 회원가입 요청 수행
      if (emailResponse.statusCode == 200 && phoneResponse.statusCode == 200) {
        final response = await http.post(
          Uri.parse('$serverUrl/signup/register'),
          body: {
            'id': idController.text,
            'password': passwordController.text,
            'name': nameController.text,
            'email': emailController.text,
            'phone': phoneController.text,
          },
        );

        if (response.statusCode == 200) {
          // 회원가입 성공
          print('회원가입 성공!');
          // 추가적인 작업 수행, 예를 들어, 로그인 화면으로 이동 등
          Navigator.pushNamed(context, '/');
        } else {
          // 회원가입 실패
          print('회원가입 실패. 서버 응답 코드: ${response.statusCode}');
          print('응답 본문: ${response.body}');
        }
      } else {
        // 이메일 또는 전화번호 인증 실패
        print('이메일 또는 전화번호 인증 실패');
      }
    } catch (error) {
      // 예외 처리
      print('회원가입 중 오류: $error');
    }
  }

  Future<void> _requestEmailVerification() async {
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/signup/emailverification'),
        body: {'email': emailController.text},
      );

      if (response.statusCode == 200) {
        // 이메일 인증 성공
        print('이메일 인증 성공!');
      } else {
        // 이메일 인증 실패
        print('이메일 인증 실패. 서버 응답 코드: ${response.statusCode}');
        print('응답 본문: ${response.body}');
      }
    } catch (error) {
      // 예외 처리
      print('이메일 인증 중 오류: $error');
    }
  }

  Future<void> _requestPhoneVerification() async {
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/signup/phoneverification'),
        body: {'phone': phoneController.text},
      );

      if (response.statusCode == 200) {
        // 전화번호 인증 성공
        print('전화번호 인증 성공!');
      } else {
        // 전화번호 인증 실패
        print('전화번호 인증 실패. 서버 응답 코드: ${response.statusCode}');
        print('응답 본문: ${response.body}');
      }
    } catch (error) {
      // 예외 처리
      print('전화번호 인증 중 오류: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
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
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: '이름'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: '이메일'),
            ),
            ElevatedButton(
              onPressed: () async {
                // 이메일 인증 요청
                await _requestEmailVerification();
              },
              child: Text('이메일 인증'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: '전화번호'),
            ),
            ElevatedButton(
              onPressed: () async {
                // 문자 인증 요청
                await _requestPhoneVerification();
              },
              child: Text('문자 인증'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _register();
              },
              child: Text('가입 완료'),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
