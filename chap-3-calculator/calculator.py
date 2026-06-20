import sys


def add(a, b):
    return a + b


def subtract(a, b):
    return a - b


def multiply(a, b):
    return a * b


def divide(a, b):
    if b == 0:
        return "Error: Division by zero"
    return a / b


def main():
    if len(sys.argv) != 4:
        print("Usage: python calculator.py <num1> <operator> <num2>")
        print("Operators: +, -, *, /")
        sys.exit(1)

    try:
        num1 = float(sys.argv[1])
        operator = sys.argv[2]
        num2 = float(sys.argv[3])
    except ValueError:
        print("Error: Please provide valid numbers")
        sys.exit(1)

    operations = {
        "+": add,
        "-": subtract,
        "*": multiply,
        "/": divide,
    }

    if operator not in operations:
        print(f"Error: Unknown operator '{operator}'")
        print("Supported operators: +, -, *, /")
        sys.exit(1)

    result = operations[operator](num1, num2)
    print(f"{num1} {operator} {num2} = {result}")


if __name__ == "__main__":
    main()
