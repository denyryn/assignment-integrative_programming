import unittest
from calculator import add, subtract, multiply, divide


class TestCalculator(unittest.TestCase):

    def test_add(self):
        self.assertEqual(add(2, 3), 5)
        self.assertEqual(add(-1, 1), 0)
        self.assertEqual(add(-5, -3), -8)
        self.assertEqual(add(0, 0), 0)

    def test_subtract(self):
        self.assertEqual(subtract(10, 5), 5)
        self.assertEqual(subtract(0, 5), -5)
        self.assertEqual(subtract(-3, -3), 0)
        self.assertEqual(subtract(100, 99), 1)

    def test_multiply(self):
        self.assertEqual(multiply(3, 4), 12)
        self.assertEqual(multiply(-2, 5), -10)
        self.assertEqual(multiply(0, 100), 0)
        self.assertEqual(multiply(-3, -3), 9)

    def test_divide(self):
        self.assertEqual(divide(10, 2), 5)
        self.assertEqual(divide(7, 2), 3.5)
        self.assertEqual(divide(-10, 2), -5)
        self.assertEqual(divide(0, 5), 0)

    def test_divide_by_zero(self):
        self.assertEqual(divide(10, 0), "Error: Division by zero")


if __name__ == "__main__":
    unittest.main()
