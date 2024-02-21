import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  TextEditingController emailCodeController = TextEditingController(); // 이메일 코드 입력 필드
  TextEditingController phoneCodeController = TextEditingController(); // 전화번호 코드 입력 필드

  final String serverUrl = 'http://15.164.151.155:8080';

  // 여기에 추가: 이메일과 전화번호 인증 성공 여부를 나타내는 변수
  bool _isEmailVerified = false;
  bool _isPhoneVerified = false;

  Future<void> _register() async {
    try {
      // 서버로 이메일 및 전화번호 인증 요청
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
          // 로그인 화면으로 이동
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

      // 이메일 인증 성공 시
      if (response.statusCode == 200) {
        // 이메일 인증 성공
        print('이메일 인증 성공!');
        // 이메일 인증이 성공하면 상태 업데이트
        setState(() {
          _isEmailVerified = true;
        });

        // 서버 응답에서 받은 이메일 코드를 저장
        final Map<String, dynamic> responseBody = json.decode(response.body);
        print('Response Body: $responseBody');
        final String emailCode = responseBody['code'].toString();
        print('Email Code: $emailCode');


        // 사용자가 입력한 이메일 코드를 서버로 전송하여 확인
        final emailCodeResponse = await http.post(
          Uri.parse('$serverUrl/signup/verifyemailcode'),
          body: {
            'email': emailController.text,
            'code': emailCodeController.text
          },
        );

        if (emailCodeResponse.statusCode == 200) {
          print('이메일 코드 인증 성공!');
          // 이메일 코드 인증이 성공하면 상태 업데이트
          setState(() {
            _isEmailVerified = true;
          });
        } else {
          print('이메일 코드 인증 실패. 서버 응답 코드: ${emailCodeResponse.statusCode}');
          print('응답 본문: ${emailCodeResponse.body}');
          // SnackBar를 사용: 이메일 코드 인증 실패 메시지를 화면에 표시
          final snackBarEmailCode = SnackBar(
            content: Text(
                '이메일 코드 인증에 실패했습니다. 서버 응답 코드: ${emailCodeResponse.statusCode}'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBarEmailCode);
        }
      } else {
        // 이메일 인증 실패
        print('이메일 인증 실패. 서버 응답 코드: ${response.statusCode}');
        print('응답 본문: ${response.body}');

        // SnackBar 사용: 이메일 인증 실패 메시지를 화면에 표시
        final snackBarEmail = SnackBar(
          content: Text('이메일 인증에 실패했습니다. 서버 응답 코드: ${response.statusCode}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBarEmail);
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

        // 전화번호 인증 성공 시
        if (response.statusCode == 200) {
        // 전화번호 인증 성공
        print('전화번호 인증 성공!');
        // 전화번호 인증이 성공하면 상태 업데이트
        setState(() {
          _isPhoneVerified = true;
        });

        // 서버 응답에서 받은 전화번호 코드를 저장
        final Map<String, dynamic> phoneResponseBody = json.decode(response.body);
        print('Phone Response Body: $phoneResponseBody');
        final String phoneCode = phoneResponseBody['code'].toString();
        print('Phone Code: $phoneCode');


        // 사용자가 입력한 전화번호 코드를 서버로 전송하여 확인
        final phoneCodeResponse = await http.post(
          Uri.parse('$serverUrl/signup/verifyphonecode'),
          body: {
            'phone': phoneController.text,
            'code': phoneCodeController.text
          },
        );

        if (phoneCodeResponse.statusCode == 200) {
          print('전화번호 코드 인증 성공!');
          // 전화번호 코드 인증이 성공하면 상태 업데이트
          setState(() {
            _isPhoneVerified = true;
          });
        } else {
          // 전화번호 인증 실패
          print('전화번호 코드 인증 실패. 서버 응답 코드: ${phoneCodeResponse.statusCode}');
          print('응답 본문: ${phoneCodeResponse.body}');
          // SnackBar 사용: 전화번호 코드 인증 실패 메시지를 화면에 표시
          final snackBarPhoneCode = SnackBar(
            content: Text('전화번호 코드 인증에 실패했습니다. 서버 응답 코드: ${phoneCodeResponse.statusCode}'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBarPhoneCode);

          // 전화번호 코드 인증이 실패하면 상태 업데이트
          setState(() {
            _isPhoneVerified = false;
          });
        }
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
            // 이메일 인증 성공 시 회원가입 버튼 활성화
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
            // 전화번호 인증 성공 시 회원가입 버튼 활성화
            ElevatedButton(
              onPressed: () async {
                // 문자 인증 요청
                await _requestPhoneVerification();
              },
              child: Text('문자 인증'),
            ),

            // 이메일, 전화번호 인증 성공 시 회원가입 버튼 활성화
            ElevatedButton(
              onPressed: () async {
                if (_isEmailVerified && _isPhoneVerified) {
                  // 이메일 및 전화번호 인증이 성공하면 회원가입 요청
                  await _register();
                } else {
                  // 인증이 되지 않았을 때의 처리
                  print('이메일 또는 전화번호 인증이 필요합니다.');

                  // SnackBar 사용: 메시지를 화면에 표시
                  final snackBar = SnackBar(
                    content: Text('이메일 또는 전화번호 인증이 필요합니다.'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
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