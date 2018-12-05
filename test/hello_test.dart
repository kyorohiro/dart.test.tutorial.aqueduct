import 'package:test/test.dart' as tt;

void main() {
  tt.test("1+1=2", () {
    tt.expect(1+1, tt.equals(2));
  });
}