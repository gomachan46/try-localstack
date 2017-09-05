import unittest
from sample import hello

class TestHello(unittest.TestCase):
    def test_hello(self):
        expected = 'Hello from Lambda'
        actual = hello()
        self.assertEqual(expected, actual)

if __name__ == "__main__":
    unittest.main()
