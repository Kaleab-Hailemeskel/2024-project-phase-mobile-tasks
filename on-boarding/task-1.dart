import 'dart:io';
import 'dart:async';

void main() async{
  double? firstOperand;
  double? secondOperand;
  String? operation;
  
  do {
    stdout.write('Enter the First Operand: ');
    try {
      firstOperand = double.parse(stdin.readLineSync()!);
    } catch (e) {
      print('===> INVALID INPUT for First Operand <===');
      continue;
    }

    stdout.write('Enter the Second Operand: ');
    try {
      secondOperand = double.parse(stdin.readLineSync()!);
    } catch (e) {
      print('===> INVALID INPUT for Second Operand <===');
      continue;
    }

    stdout.write('Enter the Operation: ');
    try {
      operation = stdin.readLineSync()!.trim();
      if (!['/', '*', '+', '-'].contains(operation)) {
        throw Error();
      }
    } catch (e) {
      print('===> INVALID INPUT for Operation <===');
      continue;
    }

    double? ans = await delayedResult(firstOperand, secondOperand, operation);
    if (ans != null) {
      print('\nThe Answer to $firstOperand $operation $secondOperand: $ans\n');
    }
  } while (promptTheUserToStay());

  print('Thanks 🤗 Have a Nice Day!');
}

Future<double?> delayedResult(double firstNum, double secondNum, String op) async {
  await Future.delayed(const Duration(seconds: 5));
  return calculate(firstNum, secondNum, op);
}

bool promptTheUserToStay() {
  stdout.write('Do You want to use the Calculator\n(type yes to continue /else to stop): ');
  String? input = stdin.readLineSync();
  return input != null && input.toLowerCase() == 'yes';
}

double? calculate(double firstNum, double secondNum, String op) {
  double? ans;
  switch (op) {
    case '/':
      try {
        if (secondNum == 0) {
          throw Error();
        }
        ans = firstNum / secondNum;
      } catch (e) {
        print('=>> Division by Zero Not Allowed <<=');
        return null;
      }
      break;
    case '*':
      ans = firstNum * secondNum;
      break;
    case '+':
      ans = firstNum + secondNum;
      break;
    case '-':
      ans = firstNum - secondNum;
      break;
    default:
  }
  return ans;
}

